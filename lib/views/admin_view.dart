import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maintenance_log/models/consumption.dart';
import 'package:maintenance_log/models/maintenance.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/models/note.dart';
import 'package:maintenance_log/models/post.dart';
import 'package:maintenance_log/models/property_value.dart';
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
    var maintenanceObject = MaintenanceObject(
        id: '1',
        name: 'name',
        description: 'description',
        meterType: MeterType.odometer,
        sortOrder: 1,
        isActive: true,
        propertyValues: [
          PropertyValue('1', 'label', 'text', 1),
          PropertyValue('2', 'label', 'text', 2)
        ],
        notes: [
          Note('1', 'name 1', 'text 1', 1, ['image 1', 'image 2']),
          Note('2', 'name 2', 'text 2', 2, ['image 1', 'image 2'])
        ],
        maintenanceItems: [
          Maintenance(
              '1',
              'name 1',
              [
                Post('1', DateTime.now(), 10000, 50, 'note 1',
                    ['image 1', 'image 2'])
              ],
              'description 1',
              1,
              true),
          Maintenance(
              '2',
              'name 2',
              [
                Post('1', DateTime.now(), 10000, 50, 'note 2',
                    ['image 1', 'image 2'])
              ],
              'description 2',
              2,
              true)
        ],
        consumptions: [
          Consumption('1', DateTime.now().subtract(Duration(days: 1)), 20.99,
              35.0, 10100),
          Consumption('1', DateTime.now(), 22, 39.0, 10200)
        ],
        images: [
          'image 1',
          'image 2'
        ]);
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
            onPressed: () async {
              // final collection = FirebaseFirestore.instance.collection('test');
              // var ref = collection.doc('1');
              // await ref.set(maintenanceObject.toMap());
            },
            icon: FaIcon(FontAwesomeIcons.car),
          ),
          ActionButton(
            onPressed: () async {
              final collection = FirebaseFirestore.instance.collection('test');
              var ref = collection.doc('1');
              var aaa = await ref.get();
              var bbb = aaa.data();
              print(bbb);
              var ccc = MaintenanceObject.fromMap(bbb as Map<String, dynamic>);
              var ddd = ccc;
            },
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
