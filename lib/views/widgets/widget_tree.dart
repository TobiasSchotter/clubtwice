import 'package:clubtwice/core/services/auth.dart';
import 'package:flutter/material.dart';
import '../screens/page_switcher.dart';
import '../screens/login_register_page/welcome_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  _WidgetTreeState createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _hideSplash();
  }

  void _hideSplash() async {
    await Future.delayed(
        const Duration(seconds: 0)); // Wartezeit für den Splashscreen
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildAppContent(),
        if (_showSplash) buildSplashScreen(),
      ],
    );
  }

  Widget _buildAppContent() {
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

  Widget buildSplashScreen() {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/splash.jpg',
            fit: BoxFit.cover,
          ),
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
