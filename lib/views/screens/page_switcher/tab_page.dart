import 'package:clubtwice/views/screens/page_switcher/message_page.dart';
import 'package:clubtwice/views/screens/page_switcher/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';

class TabPage extends StatefulWidget {
  final Function(int) onUnreadMessageCountChanged;

  const TabPage({Key? key, required this.onUnreadMessageCountChanged}) : super(key: key);

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  int _unreadMessageCount = 0;

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

  void _updateUnreadMessageCount(int count) {
    setState(() {
      _unreadMessageCount = count;
    });
    widget.onUnreadMessageCountChanged(count);
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
            Tab(text: _unreadMessageCount > 0 ? 'Nachrichten (${_unreadMessageCount})' : 'Nachrichten'),
            const Tab(text: 'Benachrichtigungen'),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          MessagePage(onUnreadMessageCountChanged: _updateUnreadMessageCount),
          NotificationPage(),
        ],
      ),
    );
  }
}
