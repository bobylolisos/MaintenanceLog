import 'package:flutter/material.dart';
import 'package:maintenance_log/views/maintenance_objects_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MaintenanceObjectsPage(),
    );
  }
}
