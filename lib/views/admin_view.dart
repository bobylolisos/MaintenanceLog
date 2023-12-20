import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/widgets/expandable_fab.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});
  void _showAction(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(index.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBlue,
      appBar: AppBar(
        backgroundColor: colorBlue,
        title: Text('Admin'),
      ),
      body: SafeArea(
        child: Container(
          color: colorLightGrey,
          child: Center(
            child: Text('Admin'),
          ),
        ),
      ),
      floatingActionButton: ExpandableFab(
        distance: 112,
        children: [
          ActionButton(
            onPressed: () => _showAction(context, 0),
            icon: const FaIcon(FontAwesomeIcons.car),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 1),
            icon: const FaIcon(FontAwesomeIcons.bicycle),
          ),
          // ActionButton(
          //   onPressed: () => _showAction(context, 2),
          //   icon: const Icon(Icons.videocam),
          // ),
          // ActionButton(
          //   onPressed: () => _showAction(context, 2),
          //   icon: const Icon(Icons.videocam),
          // ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          iconSize: 18,
          selectedFontSize: 16,
          currentIndex: 0,
          backgroundColor: colorBlue,
          selectedItemColor: colorGold,
          unselectedItemColor: colorGold.withOpacity(0.5),
          onTap: (value) {
            if (value == 1) {
              // Admin
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AdminView(),
                ),
              );
            }
          },
          items: [
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: FaIcon(
                    FontAwesomeIcons.car,
                  ),
                ),
                label: 'Objects'),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: FaIcon(
                    FontAwesomeIcons.wrench,
                  ),
                ),
                label: 'Parts'),
            // BottomNavigationBarItem(
            //     icon: Padding(
            //       padding: const EdgeInsets.all(4.0),
            //       child: FaIcon(
            //         FontAwesomeIcons.receipt,
            //       ),
            //     ),
            //     label: 'About'),
          ]),
    );
  }
}
