import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maintenance_log/setup/environment.dart';
import 'package:maintenance_log/setup/ioc.dart';
import 'views/maintenance_objects_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await setupEnvironment();
  await setupFirebase();
  setupIoc();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MaintenanceObjectsView(),
    );
  }
}
