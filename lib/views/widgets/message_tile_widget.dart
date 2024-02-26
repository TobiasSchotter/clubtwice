import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/core/model/Message.dart';
import 'package:clubtwice/views/screens/message_detail_page.dart';

class MessageTileWidget extends StatelessWidget {
  final Message data;
  final String articleTitle;
  final String articleImageUrl;
  final bool isSold;
  final bool isDeleted;
  final bool isReserved;

  const MessageTileWidget({
    Key? key,
    required this.data,
    required this.articleTitle,
    required this.articleImageUrl,
    required this.isSold,
    required this.isDeleted,
    required this.isReserved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final String currentUserID = firebaseAuth.currentUser!.uid;

    String messagePreview = data.message.split('\n')[0].length <= 40
        ? data.message.split('\n')[0]
        : '${data.message.split('\n')[0].substring(0, 40)}...';

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
            articleTitle: articleTitle,
            articleImageUrl: articleImageUrl,
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
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                //borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: articleImageUrl.isNotEmpty
                      ? NetworkImage(articleImageUrl)
                      : const AssetImage('assets/images/placeholder.jpg')
                          as ImageProvider<
                              Object>, // Cast AssetImage to ImageProvider
                  fit: BoxFit.cover,
                ),
                color: isSold
                    ? Colors.grey.withOpacity(0.5)
                    : null, // Set color if article is sold
              ),
              child: isSold || isDeleted
                  ? const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 20,
                    )
                  : isReserved
                      ? const Icon(
                          Icons.access_time,
                          color: Colors.white,
                          size: 20,
                        )
                      : null, // Show delete icon if article is sold or clock icon if reserved
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        if (isSold ||
                            isDeleted) // Check if any of the conditions are true
                          const TextSpan(
                            text: 'Gelöscht ', // Prefix with "Gelöscht"
                            style: TextStyle(
                              color: AppColor.secondary,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        if (isReserved) // Check if any of the conditions are true
                          const TextSpan(
                            text: 'Reserviert ', // Prefix with "Gelöscht"
                            style: TextStyle(
                              color: AppColor.secondary,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        if (isReserved ||
                            isSold ||
                            isDeleted) // Check if any of the conditions are true
                          const TextSpan(
                            text: '· ',
                            style: TextStyle(
                              color: AppColor.secondary,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        TextSpan(
                          text: data.receiverID == currentUserID
                              ? '${data.senderUsername} '
                              : '${data.receiverUsername} ',
                          style: const TextStyle(
                            color: AppColor.secondary,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        const TextSpan(
                          text: '· ',
                          style: TextStyle(
                            color: AppColor.secondary,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        TextSpan(
                          text: articleTitle.length > 20
                              ? '${articleTitle.substring(0, 20)}...'
                              : articleTitle,
                          style: const TextStyle(
                            color: AppColor.secondary,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    messagePreview,
                    style: TextStyle(
                      color: AppColor.secondary.withOpacity(0.7),
                      fontSize: 14,
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
