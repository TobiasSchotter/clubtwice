import 'package:clubtwice/views/screens/message_page.dart';
import 'package:clubtwice/views/screens/notification_page.dart';
import 'package:clubtwice/views/screens/register_page.dart';
import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 5,
        backgroundColor: AppColor.primarySoft,
        bottom: TabBar(
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          controller: _tabController,
          tabs: [
            Tab(text: 'Nachrichten (1)'),
            Tab(text: 'Benachrichtigungen'),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const MessagePage(),
          NotificationPage(),
        ],
      ),
    );
  }
}
