import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/core/model/Notification.dart';
import 'package:intl/intl.dart';

class NotificationTile extends StatelessWidget {
  final VoidCallback onTap;
  final UserNotification data;

  const NotificationTile({
    super.key,
    required this.onTap,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColor.border,
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: AssetImage(data.imageUrl), fit: BoxFit.cover),
              ),
              margin: const EdgeInsets.only(right: 16),
            ),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    data.title,
                    style: const TextStyle(
                        color: AppColor.secondary,
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.w500),
                  ),
                  // Description
                  Container(
                    margin: const EdgeInsets.only(top: 2, bottom: 8),
                    child: Text(
                      data.description,
                      style: TextStyle(
                          color: AppColor.secondary.withOpacity(0.7),
                          fontSize: 12),
                    ),
                  ),
                  // Datetime
                  Row(
                    children: [
                      const Icon(
                        Icons.timer_rounded,
                        size: 14,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: Text(
                          DateFormat('MM.dd HH:mm')
                              .format(data.dateTime.toLocal()),
                          style: TextStyle(
                            color: AppColor.secondary.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
