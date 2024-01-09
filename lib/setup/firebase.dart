import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future setupFirebase() async {
  var firebaseOptions = FirebaseOptions(
    apiKey: dotenv.get('ANDROID_FIREBASE_API_KEY'),
    appId: dotenv.get('ANDROID_FIREBASE_APP_ID'),
    messagingSenderId: dotenv.get('ANDROID_FIREBASE_MESSAGING_SENDER_ID'),
    projectId: dotenv.get('ANDROID_FIREBASE_PROJECT_ID'),
    storageBucket: dotenv.get('ANDROID_FIREBASE_STORAGE_BUCKET'),
  );
  await Firebase.initializeApp(
    options: firebaseOptions,
  );
}
