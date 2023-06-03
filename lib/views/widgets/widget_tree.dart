import 'package:clubtwice/core/services/auth.dart';

import 'package:flutter/material.dart';
import '../screens/page_switcher.dart';
import '../screens/welcome_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const PageSwitcher(selectedIndex: 0);
        } else {
          return const WelcomePage();
        }
      },
    );
  }
}
