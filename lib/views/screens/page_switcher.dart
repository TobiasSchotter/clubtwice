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
  int _unreadMessageCount = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Seitenwechsel wenn auf den Index für den Inbox-Bildschirm (Index 3) oder den Home-Bildschirm (Index 0) geklickt wird
    if (index == 3 || index == 0) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => PageSwitcher(selectedIndex: index),
        ),
        (route) => false,
      );
    }
  }

  void _updateUnreadMessageCount(int count) {
    setState(() {
      _unreadMessageCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const HomePage(),
          SearchPage(),
          const SellPage(
            isIndividuallyWearable: false,
            images: [],
          ),
          TabPage(onUnreadMessageCountChanged: _updateUnreadMessageCount),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        height: 60,
        backgroundColor: AppColor.primarySoft,
        onDestinationSelected: _onDestinationSelected,
        selectedIndex: _selectedIndex,
        destinations: <Widget>[
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Club',
          ),
          const NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Suche',
          ),
          const NavigationDestination(
            icon: Icon(Icons.sell_outlined),
            selectedIcon: Icon(Icons.sell),
            label: 'Verkaufen',
          ),
          NavigationDestination(
            icon: Stack(
              children: [
                const Icon(Icons.mail_outlined),
                if (_unreadMessageCount > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '$_unreadMessageCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            selectedIcon: Stack(
              children: [
                const Icon(Icons.mail),
                if (_unreadMessageCount > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '$_unreadMessageCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Inbox',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
