import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clubtwice/core/model/Message.dart';
import 'package:clubtwice/core/services/MessageService.dart';
import 'package:clubtwice/views/widgets/message_tile_widget.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late Future<List<Message>> _listMessageFuture;

  @override
  void initState() {
    super.initState();
    _listMessageFuture = MessageService().getUserChatsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Message>>(
        future: _listMessageFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Message> listMessage = snapshot.data!;
            if (listMessage.isEmpty) {
              return const Center(
                child: Text('Du hast noch keine Nachrichten erhalten'),
              );
            } else {
              return ListView.builder(
                itemCount: listMessage.length,
                itemBuilder: (context, index) {
                  // Fetch user data for the receiver
                  Future<DocumentSnapshot> receiverDocFuture = FirebaseFirestore
                      .instance
                      .collection('users')
                      .doc(listMessage[index].receiverID)
                      .get();

                  // Fetch user data for the sender
                  Future<DocumentSnapshot> senderDocFuture = FirebaseFirestore
                      .instance
                      .collection('users')
                      .doc(listMessage[index].senderId)
                      .get();

                  return FutureBuilder(
                    future: Future.wait([receiverDocFuture, senderDocFuture]),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const SizedBox();
                      } else if (userSnapshot.hasError) {
                        return const SizedBox();
                      } else {
                        // Extract receiver and sender document snapshots
                        DocumentSnapshot receiverSnapshot =
                            userSnapshot.data![0] as DocumentSnapshot;
                        DocumentSnapshot senderSnapshot =
                            userSnapshot.data![1] as DocumentSnapshot;

                        // Check if both receiver and sender exist
                        bool bothUsersExist =
                            receiverSnapshot.exists && senderSnapshot.exists;

                        // Only build message tile if both users exist
                        if (bothUsersExist) {
                          // Fetch article data
                          Future<DocumentSnapshot> articleDocFuture =
                              FirebaseFirestore.instance
                                  .collection('articles')
                                  .doc(listMessage[index].articleId)
                                  .get();

                          return FutureBuilder(
                            future: articleDocFuture,
                            builder: (context, articleSnapshot) {
                              if (articleSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox();
                              } else if (articleSnapshot.hasError) {
                                return const SizedBox();
                              } else if (!articleSnapshot.hasData ||
                                  !articleSnapshot.data!.exists) {
                                return const SizedBox();
                              } else {
                                // Extract article data
                                String articleTitle =
                                    articleSnapshot.data!['title'];
                                bool isSold =
                                    articleSnapshot.data?['isSold'] ?? false;
                                bool isDeleted =
                                    articleSnapshot.data?['isDeleted'] ?? false;
                                bool isReserved =
                                    articleSnapshot.data?['isReserved'] ??
                                        false;
                                List<dynamic> images =
                                    articleSnapshot.data!['images'];
                                String imageUrl =
                                    (images.isNotEmpty && images[0] != null)
                                        ? images[0]
                                        : '';

                                int unreadCount = 0;

                                if (listMessage[index].senderId !=
                                    FirebaseAuth.instance.currentUser!.uid) {
                                  unreadCount =
                                      listMessage[index].isRead ? 0 : 1;
                                }

                                return GestureDetector(
                                  
                                  child: Dismissible(
                                    key: UniqueKey(),
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      color: Colors.red,
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.only(right: 20.0),
                                      child: Icon(Icons.delete),
                                    ),
                                    onDismissed: (direction) {
                                      // Implement delete action here
                                      // For now, we can just print a message
                                      print('Deleted message');
                                    },
                                    child: MessageTileWidget(
                                      data: listMessage[index],
                                      articleTitle: articleTitle,
                                      articleImageUrl: imageUrl,
                                      isSold: isSold,
                                      isDeleted: isDeleted,
                                      isReserved: isReserved,
                                      unreadMessageCount: unreadCount,
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        } else {
                          // Don't build message tile if either user doesn't exist
                          return const SizedBox();
                        }
                      }
                    },
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
