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
    //get current user info
    final String currentUserID = _firebaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    //fetch receiver username
    final DocumentSnapshot receiverDoc =
        await _firestore.collection('users').doc(receiverID).get();

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
    await _updateParticipants(chatRoomID, currentUserID, receiverID, articleId);
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

    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
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
