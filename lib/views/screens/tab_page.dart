import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';

class TabPage extends StatefulWidget {
  const TabPage({super.key});

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
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
