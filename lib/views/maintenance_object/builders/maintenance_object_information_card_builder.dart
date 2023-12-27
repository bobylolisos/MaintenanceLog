import 'package:flutter/material.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/widgets/maintenance_object_item_card.dart';

class MaintenanceObjectInformationCardBuilder {
  static Widget create(MaintenanceObject maintenanceObject) {
    return MaintenanceObjectItemCard(
      title: 'Information',
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            maintenanceObject.name,
            style: TextStyle(color: colorBlue, fontSize: 20),
          ),
          Text(
            maintenanceObject.shortDescription,
            style: TextStyle(color: colorBlue, fontSize: 14),
          ),
          SizedBox(
            height: 5,
          ),
          Builder(
            builder: (context) {
              final widgets = List<Widget>.empty(growable: true);
              for (var propertyValue in maintenanceObject.propertyValues) {
                if (propertyValue.label.isEmpty) {
                  widgets.add(Text(
                    propertyValue.text,
                    style: TextStyle(color: colorBlue, fontSize: 14),
                  ));
                } else {
                  widgets.add(Text(
                    '${propertyValue.label}: ${propertyValue.text}',
                    style: TextStyle(color: colorBlue, fontSize: 14),
                  ));
                }
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widgets.toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
