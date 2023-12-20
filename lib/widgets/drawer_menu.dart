import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/views/about_view.dart';
import 'package:maintenance_log/views/admin_view.dart';
import 'package:maintenance_log/views/settings_view.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: colorBlue,
      surfaceTintColor: Colors.black,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(border: null, boxShadow: null),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Image.asset(
                    'assets/logo_foreground.png',
                    height: 80,
                  ),
                ),
                Text(
                  'Maintenance log',
                  style: TextStyle(fontSize: 22, color: colorGold),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: colorLightGrey,
              child: Column(
                children: [
                  ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.puzzlePiece,
                      size: 30,
                      color: colorBlue,
                    ),
                    title: Text(
                      'Admin',
                      style: TextStyle(color: colorBlue, fontSize: 20),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AdminView(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.gear,
                      size: 30,
                      color: colorBlue,
                    ),
                    title: Text(
                      'Settings',
                      style: TextStyle(color: colorBlue, fontSize: 20),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SettingsView(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.receipt,
                      size: 30,
                      color: colorBlue,
                    ),
                    title: Text(
                      'About',
                      style: TextStyle(color: colorBlue, fontSize: 20),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AboutView(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
