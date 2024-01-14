import 'package:flutter/material.dart';
import 'package:maintenance_log/models/maintenance_object.dart';

class AdminMaintenanceObjectMaintenanceTabView extends StatelessWidget {
  final MaintenanceObject maintenanceObject;
  const AdminMaintenanceObjectMaintenanceTabView(
      {required this.maintenanceObject, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('MAINTENANCE'));
  }
}
