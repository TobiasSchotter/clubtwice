import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:clubtwice/core/model/Message.dart';
import 'package:clubtwice/core/services/MessageService.dart';
import 'package:clubtwice/views/widgets/message_tile_widget.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
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
              // Wenn die Liste leer ist, zeige eine Nachricht an
              return Center(
                  child: Text('Du hast noch keine Nachrichten erhalten'));
            } else {
              return ListView.builder(
                itemCount: listMessage.length,
                itemBuilder: (context, index) {
                  // Perform a query to get the article document by its ID
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('articles')
                        .doc(listMessage[index].articleId)
                        .get(),
                    builder: (context, articleSnapshot) {
                      if (articleSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return SizedBox(); // Return an empty widget while waiting for the query result
                      } else if (articleSnapshot.hasError) {
                        return SizedBox(); // Handle error state
                      } else if (!articleSnapshot.hasData ||
                          !articleSnapshot.data!.exists) {
                        return SizedBox(); // Handle case where the article document does not exist
                      } else {
                        // Extract article data from the document snapshot
                        String articleTitle = articleSnapshot.data!['title'];
                        bool isSold = articleSnapshot.data?['isSold'];
                        bool isDeleted = articleSnapshot.data?['isDeleted'];
                        bool isReserved = articleSnapshot.data?['isReserved'];
                        List<dynamic> images = articleSnapshot.data!['images'];
                        String imageUrl =
                            (images.isNotEmpty && images[0] != null)
                                ? images[0]
                                : '';

                        // Return the MessageTileWidget with the article data
                        return MessageTileWidget(
                          data: listMessage[index],
                          articleTitle: articleTitle,
                          articleImageUrl: imageUrl,
                          isSold: isSold,
                          isDeleted: isDeleted,
                          isReserved: isReserved,
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
