import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maintenance_log/setup/environment.dart';
import 'package:maintenance_log/setup/firebase.dart';
import 'package:maintenance_log/setup/ioc.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await setupEnvironment();
  await setupFirebase();
  setupIoc();

  // DefaultCacheManager manager = DefaultCacheManager();
  // await manager.emptyCache();

  runApp(const App());
}
