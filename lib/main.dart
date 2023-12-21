import 'package:devfest/boarding.dart';
import 'package:devfest/homepage.dart';
import 'package:devfest/pages.dart';
import 'package:devfest/result.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDsThFDDU_H2UTDFgv8IpFs-yOzpOZgbs0",
        authDomain: "devfest-c0b36.firebaseapp.com",
        projectId: "devfest-c0b36",
        storageBucket: "devfest-c0b36.appspot.com",
        messagingSenderId: "313833665500",
        appId: "1:313833665500:web:8b8ff1ea5f2b549105d519",
        measurementId: "G-87KCV5PBME"),
    // const firebaseConfig = {

// };
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Devfest - Salem',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AllPages(),
    );
  }
}
