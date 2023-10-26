import 'package:flutter/material.dart';
import 'package:clubtwice/core/model/Notification.dart';
import 'package:clubtwice/core/services/NotificationService.dart';
import 'package:clubtwice/views/widgets/notification_tile.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<UserNotification> listNotification =
      NotificationService.listNotification;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  itemBuilder: (context, index) {
                    return NotificationTile(
                      data: listNotification[index],
                      onTap: () {},
                    );
                  },
                  itemCount: listNotification.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
