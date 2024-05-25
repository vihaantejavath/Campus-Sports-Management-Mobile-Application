import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:arjuna/pages/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCSl2ooN9NkKMlw8vaAHfafaEB5a8PWbwg",
      appId: "1:785765470210:android:7b66e75b216d24bda2d71b",
      messagingSenderId: "785765470210",
      projectId: "arjuna-69671",
      storageBucket: "arjuna-69671.appspot.com",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const Homepage(),
    );
  }
}
