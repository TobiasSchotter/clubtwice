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
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(listMessage[index].receiverID)
                        .get(),
                    builder: (context, receiverSnapshot) {
                      if (receiverSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const SizedBox();
                      } else if (receiverSnapshot.hasError) {
                        return const SizedBox();
                      } else if (!receiverSnapshot.hasData ||
                          !receiverSnapshot.data!.exists) {
                        return const SizedBox();
                      } else {
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('articles')
                              .doc(listMessage[index].articleId)
                              .get(),
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
                              String articleTitle =
                                  articleSnapshot.data!['title'];
                              bool isSold =
                                  articleSnapshot.data?['isSold'] ?? false;
                              bool isDeleted =
                                  articleSnapshot.data?['isDeleted'] ?? false;
                              bool isReserved =
                                  articleSnapshot.data?['isReserved'] ?? false;
                              List<dynamic> images =
                                  articleSnapshot.data!['images'];
                              String imageUrl =
                                  (images.isNotEmpty && images[0] != null)
                                      ? images[0]
                                      : '';

                              int unreadCount = 0;

                              if (listMessage[index].senderId !=
                                  FirebaseAuth.instance.currentUser!.uid) {
                                unreadCount = listMessage[index].isRead ? 0 : 1;
                              }

                              return MessageTileWidget(
                                data: listMessage[index],
                                articleTitle: articleTitle,
                                articleImageUrl: imageUrl,
                                isSold: isSold,
                                isDeleted: isDeleted,
                                isReserved: isReserved,
                                unreadMessageCount: unreadCount,
                              );
                            }
                          },
                        );
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
