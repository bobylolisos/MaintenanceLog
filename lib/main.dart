import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'views/main_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await dotenv.load();

  var firebaseOptions = FirebaseOptions(
    apiKey: dotenv.get('ANDROID_FIREBASE_API_KEY'),
    appId: dotenv.get('ANDROID_FIREBASE_APP_ID'),
    messagingSenderId: dotenv.get('ANDROID_FIREBASE_MESSAGING_SENDER_ID'),
    projectId: dotenv.get('ANDROID_FIREBASE_PROJECT_ID'),
    storageBucket: dotenv.get('ANDROID_FIREBASE_STORAGE_BUCKET'),
  );
  final app = await Firebase.initializeApp(
    options: firebaseOptions,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainView(),
    );
  }
}
