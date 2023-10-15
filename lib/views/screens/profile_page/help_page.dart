import 'package:clubtwice/views/screens/help_page/agb_page.dart';
import 'package:clubtwice/views/screens/help_page/delete_page.dart';
import 'package:clubtwice/views/screens/help_page/feedback_page.dart';
import 'package:clubtwice/views/screens/help_page/impressum_page.dart';
import 'package:clubtwice/views/screens/help_page/rate_page.dart';
import 'package:clubtwice/views/screens/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/views/widgets/menu_tile_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../help_page/datenschutz.dart';
import '../help_page/notiffication_page.dart';
import '../../../core/services/user_service.dart';

class HelpPage extends StatefulWidget {
  HelpPage({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  bool confirm = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Hilfe',
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600)),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_outlined),
          color: Colors.black,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          // Section 2 - Account Menu
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(top: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MenuTileWidget(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const NotificationPage()));
                  },
                  margin: const EdgeInsets.only(top: 10),
                  icon: Icon(
                    Icons.help_center_outlined,
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'Benachrichtigungen',
                  subtitle:
                      'Passe hier deine Benachrichtigungen zu neuen Artikel etc. an',
                ),
                MenuTileWidget(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const RatePage()));
                  },
                  margin: const EdgeInsets.only(top: 10),
                  icon: Icon(
                    Icons.help_center_outlined,
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'App bewerten',
                  subtitle: 'Bewerte unsere App',
                ),
                MenuTileWidget(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const FeedbackPage()));
                  },
                  margin: const EdgeInsets.only(top: 10),
                  icon: Icon(
                    Icons.help_center_outlined,
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'Feedback an ClubTwice',
                  subtitle: 'Helfe uns besser zu werden',
                ),
                MenuTileWidget(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AgbPage()));
                  },
                  margin: const EdgeInsets.only(top: 10),
                  icon: Icon(
                    Icons.help_center_outlined,
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'AGB',
                  subtitle: 'Hier findest du unsere AGB',
                ),
                MenuTileWidget(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const DatenschutzPage()));
                  },
                  margin: const EdgeInsets.only(top: 10),
                  icon: Icon(
                    Icons.help_center_outlined,
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'Datenschutz',
                  subtitle: 'Hier findest du unsere Datenschutz-Richtlinien',
                ),
                MenuTileWidget(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ImpressumPage()));
                  },
                  margin: const EdgeInsets.only(top: 10),
                  icon: Icon(
                    Icons.help_center_outlined,
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'Impressum',
                  subtitle: 'Hier findest du unser Impressum',
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 16),
                        child: Text(
                          'Abmelden',
                          style: TextStyle(
                              color: AppColor.secondary.withOpacity(0.5),
                              letterSpacing: 6 / 100,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      MenuTileWidget(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const DeletePage()));
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          color: AppColor.secondary.withOpacity(0.5),
                        ),
                        title: 'Account löschen',
                        subtitle: 'Lösche deinen Account hier',
                      ),
                      MenuTileWidget(
                        onTap: () async {
                          // Show a dialog to confirm the sign out
                          bool confirm = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Abmelden'),
                              content: const Text(
                                  'Möchtest du dich wirklich abmelden?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Nein'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Ja'),
                                ),
                              ],
                            ),
                          );
                          // Sign out if confirmed
                          if (confirm == true) {
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const WelcomePage()),
                            );
                            widget.signOut();
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Abmeldung erfolgreich'),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.logout_outlined,
                            color: Colors.red),
                        iconBackground: Colors.red[50]!,
                        title: 'Ausloggen',
                        subtitle: 'Hier kannst du dich ausloggen',
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
