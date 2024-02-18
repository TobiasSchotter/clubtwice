import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/core/model/Message.dart';
import 'package:clubtwice/views/screens/message_detail_page.dart';

class MessageTileWidget extends StatelessWidget {
  final Message data;

  const MessageTileWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final String currentUserID = firebaseAuth.currentUser!.uid;

    return GestureDetector(
      onTap: () {
        final String receiverId =
            data.receiverID == currentUserID ? data.senderId : data.receiverID;
        final String receiverUsername = data.receiverID == currentUserID
            ? data.senderUsername
            : data.receiverUsername;
        final String senderId =
            data.receiverID == currentUserID ? data.receiverID : data.senderId;

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MessageDetailPage(
            receiverId: receiverId,
            receiverUsername: receiverUsername,
            senderId: senderId,
            articleId: data.articleId,
          ),
        ));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: AppColor.primarySoft, width: 1)),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 56,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage('assets/images/placeholder.jpg'),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.receiverID == currentUserID
                        ? data.senderUsername
                        : data.receiverUsername,
                    style: const TextStyle(
                      color: AppColor.secondary,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data.message,
                    style: TextStyle(
                      color: AppColor.secondary.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColor.border,
            ),
          ],
        ),
      ),
    );
  }
}
