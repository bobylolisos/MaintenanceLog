import 'package:flutter/material.dart';
import 'package:maintenance_log/models/maintenance_item.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/widgets/maintenance_object_item_card.dart';
import 'package:maintenance_log/widgets/sub_header_app_bar.dart';

class MaintenanceItemPage extends StatefulWidget {
  final String maintenanceObjectName;
  final MaintenanceItem maintenanceItem;

  const MaintenanceItemPage(
      {required this.maintenanceObjectName,
      required this.maintenanceItem,
      super.key});

  @override
  State<MaintenanceItemPage> createState() => _MaintenanceItemPageState();
}

class _MaintenanceItemPageState extends State<MaintenanceItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorLightGrey,
        appBar: SubHeaderAppBar(
          title: widget.maintenanceObjectName,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 6.0, right: 6, top: 6),
          child: SingleChildScrollView(
            child: Column(
              children: [
                MaintenanceObjectItemCard(
                  title: 'Grunddata',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [],
                  ),
                ),
                MaintenanceObjectItemCard(
                  title: 'Bilder',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class WidgetMaintenanceObjectItemCard {}
