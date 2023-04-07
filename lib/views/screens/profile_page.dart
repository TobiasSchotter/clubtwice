import 'package:clubtwice/views/screens/profile_page_fav.dart';
import 'package:clubtwice/views/screens/profile_page_item.dart';
import 'package:clubtwice/views/screens/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/views/widgets/menu_tile_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          // Section 1 - Profile Picture - Username - Name
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                // Profile Picture
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey,
                    image: const DecorationImage(
                      image: AssetImage('assets/images/pp.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Fullname
                Container(
                  margin: const EdgeInsets.only(bottom: 4, top: 14),
                  child: const Text(
                    'Riccardo Bal',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                ),
                // Username
                Text(
                  '@RicBal',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.6), fontSize: 14),
                ),
                Text(
                  'SG Quelle Fürth',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.6), fontSize: 14),
                ),
                Text(
                  'Fußball',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.6), fontSize: 14),
                ),
              ],
            ),
          ),
          // Section 2 - Account Menu
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
                    'Account',
                    style: TextStyle(
                        color: AppColor.secondary.withOpacity(0.5),
                        letterSpacing: 6 / 100,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                MenuTileWidget(
                  onTap: () {},
                  margin: const EdgeInsets.only(top: 10),
                  icon: Icon(
                    Icons.person_outlined,
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'Profil',
                  subtitle: 'Passe dein Profil und Vereinszugehörigkeit an',
                ),
                MenuTileWidget(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfilePageItem()));
                  },
                  margin: const EdgeInsets.only(top: 10),
                  icon: Icon(
                    Icons.sell_outlined,
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'Meine Anzeigen',
                  subtitle:
                      'Passe deine Anzeigen hier an oder lösche deine Anzeigen',
                ),
                MenuTileWidget(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfilePageFav()));
                  },
                  margin: const EdgeInsets.only(top: 10),
                  icon: Icon(
                    Icons.favorite_border_outlined,
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'Favoriten',
                  subtitle:
                      'Markiere deine Favoriten und finde Sie hier wieder',
                ),
              ],
            ),
          ),

          // Section 3 - Settings
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
                    'Einstellungen',
                    style: TextStyle(
                        color: AppColor.secondary.withOpacity(0.5),
                        letterSpacing: 6 / 100,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                MenuTileWidget(
                  onTap: () {},
                  margin: const EdgeInsets.only(top: 10),
                  icon: Icon(
                    Icons.password_outlined,
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'Passwort',
                  subtitle: 'Ändere hier dein Passwort',
                ),
                MenuTileWidget(
                  onTap: () {},
                  margin: const EdgeInsets.only(top: 10),
                  icon: Icon(
                    Icons.mail_lock_outlined,
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'E-Mail',
                  subtitle: 'Ändere hier deine E-Mail Adresse',
                ),
                MenuTileWidget(
                  onTap: () {},
                  margin: const EdgeInsets.only(top: 10),
                  icon: Icon(
                    Icons.help_center_outlined,
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'Hilfe',
                  subtitle: 'Wie können wir dir weiterhelfen?',
                ),
                MenuTileWidget(
                  onTap: () {},
                  margin: const EdgeInsets.only(top: 10),
                  icon: Icon(
                    Icons.delete_outline,
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'Account löschen',
                  subtitle: 'Lösche dein Account hier',
                ),
                MenuTileWidget(
                  onTap: () async {
                    // Show a dialog to confirm the sign out
                    bool confirm = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Abmelden'),
                        content:
                            const Text('Möchtest du dich wirklich abmelden?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Nein'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Ja'),
                          ),
                        ],
                      ),
                    );
                    // Sign out if confirmed
                    if (confirm == true) {
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => WelcomePage()),
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
                  icon: const Icon(Icons.logout_outlined, color: Colors.red),
                  iconBackground: Colors.red[50]!,
                  title: 'Ausloggen',
                  subtitle: 'Hier kannst du dich ausloggen',
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
