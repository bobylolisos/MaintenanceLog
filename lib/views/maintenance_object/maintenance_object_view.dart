import 'package:flutter/material.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/widgets/sub_header_app_bar.dart';

class MaintenanceObjectView extends StatelessWidget {
  const MaintenanceObjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorLightGrey,
      appBar: SubHeaderAppBar(title: 'Maintenance'),
      body: Center(
        child: Text('MaintenanceObjectView'),
      ),
    );
  }
}
