import 'package:clubtwice/views/screens/message_page.dart';
import 'package:clubtwice/views/screens/notification_page.dart';
import 'package:clubtwice/views/screens/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';

class TabPage extends StatefulWidget {
  const TabPage({super.key});

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  List<Map<String, dynamic>>? _pages;
  int _selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    _pages = [
      {
        'page': NotificationPage(),
      },
      {
        'page': const WelcomePage(),
      },
    ];
    super.initState();
  }

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
          body: _pages![_selectedPageIndex]['page'],
        ),
      );
}
