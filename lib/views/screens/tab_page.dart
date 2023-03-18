import 'dart:html';

import 'package:clubtwice/views/screens/message_detail_page.dart';
import 'package:clubtwice/views/screens/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/core/model/Message.dart';
import 'package:clubtwice/core/services/MessageService.dart';
import 'package:clubtwice/views/widgets/message_tile_widget.dart';

class TabPage extends StatefulWidget {
  const TabPage({super.key});

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  List<Message> listMessage = MessageService.messageData;

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 5,
            backgroundColor: AppColor.primarySoft,
            bottom: const TabBar(
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              tabs: [
                Tab(
                  text: 'Nachrichten',
                ),
                Tab(
                  text: 'Benachrichtungen',
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [],
          ),
        ),
      );
}
