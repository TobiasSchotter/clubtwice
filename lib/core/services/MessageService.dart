import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubtwice/core/model/Message.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageService {
  final CollectionReference articlesCollection =
      FirebaseFirestore.instance.collection('articles');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future sendMessage(
      String receiverID, String message, String articleId) async {
    try {
      //get current user info
      final String currentUserID = _firebaseAuth.currentUser!.uid;
      final Timestamp timestamp = Timestamp.now();

      //fetch receiver username
      final DocumentSnapshot receiverDoc =
          await _firestore.collection('users').doc(receiverID).get();

      // Check if the receiver document exists
      if (!receiverDoc.exists) {
        // Handle the case when the receiver document doesn't exist
        print('Receiver document does not exist.');
        return; // Exit the function
      }

      //fetch sender username
      final DocumentSnapshot senderDoc =
          await _firestore.collection('users').doc(currentUserID).get();

      //create a new message
      Message newMessage = Message(
        senderId: currentUserID,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp.toDate(),
        articleId: articleId,
        receiverUsername: receiverDoc['username'],
        senderUsername: senderDoc['username'],
        isRead: false,
      );

      //construct chatID
      List<String> ids = [currentUserID, receiverID, articleId];
      ids.sort();
      String chatRoomID = ids.join('_');

      // add message to firestore subcollection of articles
      await _firestore
          .collection('chats')
          .doc(chatRoomID)
          .collection('messages')
          .add(newMessage.toMap());

      // Update participants list
      await _updateParticipants(
          chatRoomID, currentUserID, receiverID, articleId);
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error sending message: $error');
    }
  }

  Future<void> _updateParticipants(String chatRoomID, String currentUserID,
      String receiverID, String articleId) async {
    // Construct participants list
    List<String> participants = [currentUserID, receiverID];
    participants.sort();

    // Add or update participants list in the chat room document
    await _firestore.collection('chats').doc(chatRoomID).set(
        {'participants': participants, 'articleId': articleId},
        SetOptions(merge: true));
  }

  Stream<QuerySnapshot> getMessages(
      String articleId, String userID, String userID2) {
    List<String> ids = [userID, userID2, articleId];
    ids.sort();
    String chatRoomID = ids.join('_');

    // Update the isRead flag when fetching messages
    // Use a transaction to ensure atomicity
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((querySnapshot) {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        // Iterate over each message document in the snapshot
        for (DocumentSnapshot doc in querySnapshot.docs) {
          // Check if the message is sent to the current user
          if (doc['receiverID'] == userID) {
            // Update the isRead flag to true
            transaction.update(doc.reference, {'isRead': true});
          }
        }
      });
      // Return the original query snapshot
      return querySnapshot;
    });
  }

  Future<int> getUnreadMessageCount(String articleId, String userId) async {
    QuerySnapshot unreadMessages = await FirebaseFirestore.instance
        .collection('messages')
        .where('articleId', isEqualTo: articleId)
        .where('receiverId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    return unreadMessages.size;
  }

  Future<List<Message>> getUserChatsData() async {
    List<Message> messageList = [];
    final String currentUserID = _firebaseAuth.currentUser!.uid;

    // Query the 'chats' collection for all documents where the current user is a participant
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: currentUserID)
        .get();

    // Iterate over each chat room document and extract the latest message
    for (QueryDocumentSnapshot chatRoom in querySnapshot.docs) {
      // Get the messages in the chat room ordered by timestamp
      QuerySnapshot messagesSnapshot = await chatRoom.reference
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      // Check if there is a message in the chat room
      if (messagesSnapshot.docs.isNotEmpty) {
        Map<String, dynamic> messageData =
            messagesSnapshot.docs.first.data() as Map<String, dynamic>;
        Message latestMessage =
            Message.fromJson(messageData, chatRoom['articleId']);
        messageList.add(latestMessage);
      }
    }

    return messageList;
  }
}
