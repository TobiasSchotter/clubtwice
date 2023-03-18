import 'package:clubtwice/views/screens/message_page.dart';
import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/views/screens/feeds_page.dart';
import 'package:clubtwice/views/screens/home_page.dart';
import 'package:clubtwice/views/screens/notification_page.dart';
import 'package:clubtwice/views/screens/profile_page.dart';

class PageSwitcher extends StatefulWidget {
  @override
  _PageSwitcherState createState() => _PageSwitcherState();
}

class _PageSwitcherState extends State<PageSwitcher> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        HomePage(),
        FeedsPage(),
        NotificationPage(),
        MessagePage(),
        ProfilePage(),
      ][_selectedIndex],
      bottomNavigationBar: NavigationBar(
        height: 60,
        backgroundColor: AppColor.primarySoft,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Start',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Suchen',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            label: 'Verkaufen',
          ),
          NavigationDestination(
            icon: Icon(Icons.mail_outline),
            label: 'Nachrichten',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
