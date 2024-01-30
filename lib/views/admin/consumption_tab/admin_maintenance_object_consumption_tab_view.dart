import 'package:flutter/material.dart';
import 'package:maintenance_log/models/maintenance_object.dart';

class AdminMaintenanceObjectConsumptionTabView extends StatelessWidget {
  final MaintenanceObject maintenanceObject;
  const AdminMaintenanceObjectConsumptionTabView(
      {required this.maintenanceObject, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('CONSUMPTION'));
  }
}
