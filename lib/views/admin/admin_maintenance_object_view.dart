import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maintenance_log/extensions/meter_type_extensions.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/widgets/maintenance_object_item_card.dart';
import 'package:maintenance_log/widgets/sub_header_app_bar.dart';

class AdminMaintenanceObjectView extends StatelessWidget {
  final MaintenanceObject maintenanceObject;
  final ValueNotifier<int> _selectedTabIndexNotifier = ValueNotifier<int>(0);

  AdminMaintenanceObjectView({required this.maintenanceObject, super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _selectedTabIndexNotifier,
      builder: (context, value, child) => Scaffold(
        backgroundColor: colorLightGrey,
        appBar: SubHeaderAppBar(title: maintenanceObject.name),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 6, top: 6),
            child: Builder(builder: (context) {
              if (_selectedTabIndexNotifier.value == 0) {
                return _informationView();
              }
              return Center(child: Text('N O T   I M P L E M E N T E D'));
            }),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            iconSize: 18,
            selectedFontSize: 16,
            currentIndex: _selectedTabIndexNotifier.value,
            backgroundColor: colorBlue,
            selectedItemColor: colorGold,
            unselectedItemColor: colorGold.withOpacity(0.5),
            onTap: (value) {
              _selectedTabIndexNotifier.value = value;
            },
            items: [
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: FaIcon(
                      FontAwesomeIcons.house,
                    ),
                  ),
                  label: 'Information'),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: FaIcon(
                      FontAwesomeIcons.gasPump,
                    ),
                  ),
                  label: 'Förbrukning'),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: FaIcon(
                      FontAwesomeIcons.wrench,
                    ),
                  ),
                  label: 'Underhåll'),
            ]),
      ),
    );
  }

  Widget _informationView() {
    return Column(
      children: [
        MaintenanceObjectItemCard(
          title: 'Grunddata',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _paddedText(maintenanceObject.name, fontSize: 24),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 35,
                    decoration: BoxDecoration(
                      color: colorBlue,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorBlue,
                        width: 2.0,
                      ),
                    ),
                    child: InkWell(
                      splashColor: colorGold,
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {},
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: FaIcon(
                          FontAwesomeIcons.pen,
                          color: colorGold,
                          size: 15,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              _paddedText(maintenanceObject.shortDescription),
              _paddedText(maintenanceObject.meterType.displayName),
              maintenanceObject.isActive
                  ? _paddedText('Aktiv')
                  : _paddedText('Inaktiv', fontColor: Colors.red),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        MaintenanceObjectItemCard(
          title: 'Övrig data',
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: maintenanceObject.propertyValues.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: maintenanceObject.propertyValues
                            .map((e) => e.label.isNotEmpty
                                ? _paddedText('${e.label}: ${e.text}')
                                : _paddedText(e.text))
                            .toList(),
                      )
                    : _paddedText(
                        'Här kan du lägga till egen information om objektet, t.ex. årsmodell, färg, tillverkare etc.'),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                height: 35,
                decoration: BoxDecoration(
                  color: colorBlue,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorBlue,
                    width: 2.0,
                  ),
                ),
                child: InkWell(
                  splashColor: colorGold,
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {},
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: FaIcon(
                      FontAwesomeIcons.pen,
                      color: colorGold,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _paddedText(String text, {double? fontSize, Color? fontColor}) {
    if (text.isEmpty) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Text(
        text,
        maxLines: 10,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: fontColor ?? colorBlue, fontSize: fontSize),
      ),
    );
  }
}
