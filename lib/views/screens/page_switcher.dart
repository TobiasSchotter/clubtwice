import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/views/screens/page_switcher/home_page.dart';
import 'package:clubtwice/views/screens/page_switcher/profile_page.dart';
import 'package:clubtwice/views/screens/page_switcher/search_page.dart';
import 'package:clubtwice/views/screens/page_switcher/sell_page.dart';
import 'package:clubtwice/views/screens/page_switcher/tab_page.dart';

class PageSwitcher extends StatefulWidget {
  final int selectedIndex;
  const PageSwitcher({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<PageSwitcher> createState() => _PageSwitcherState();
}

class _PageSwitcherState extends State<PageSwitcher> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onDestinationSelected(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
    // Seitenwechsel nur wenn auf den Index für den Inbox-Bildschirm geklickt wird
    if (index == 3) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const PageSwitcher(
            // selectedIndex: index,
            selectedIndex: 3,
          ),
        ),
        (route) => false,
      );
    }
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
        onDestinationSelected: _onDestinationSelected,
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Club',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Suche',
          ),
          NavigationDestination(
            icon: Icon(Icons.sell_outlined),
            selectedIcon: Icon(Icons.sell),
            label: 'Verkaufen',
          ),
          NavigationDestination(
            icon: Icon(Icons.mail_outlined),
            selectedIcon: Icon(Icons.mail),
            label: 'Inbox',
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
