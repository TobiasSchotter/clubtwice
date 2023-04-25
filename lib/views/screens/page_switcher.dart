import 'package:clubtwice/views/screens/search_page.dart';
import 'package:clubtwice/views/screens/sell_page.dart';
import 'package:clubtwice/views/screens/tab_page.dart';
import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/views/screens/home_page.dart';
import 'package:clubtwice/views/screens/profile_page.dart';

class PageSwitcher extends StatefulWidget {
  final int selectedIndex;

  PageSwitcher({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<PageSwitcher> createState() => _PageSwitcherState();
}

class _PageSwitcherState extends State<PageSwitcher> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const HomePage(),
          SearchPage(),
          const SellPage(),
          TabPage(),
          ProfilePage(),
        ],
      ),
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
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Start',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Suchen',
          ),
          NavigationDestination(
            icon: Icon(Icons.sell_outlined),
            selectedIcon: Icon(Icons.sell),
            label: 'Verkaufen',
          ),
          NavigationDestination(
            icon: Icon(Icons.mail_outlined),
            selectedIcon: Icon(Icons.mail),
            label: 'Nachrichten',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
