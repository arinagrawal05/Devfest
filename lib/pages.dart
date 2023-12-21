import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devfest/boarding.dart';
import 'package:devfest/result.dart';
import 'package:devfest/waiting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';

class AllPages extends StatefulWidget {
  const AllPages({super.key});

  @override
  _AllPagesState createState() => _AllPagesState();
}

class _AllPagesState extends State<AllPages> {
  User? user = FirebaseAuth.instance.currentUser;

  String currentState = "boardinga";
  void listenToFirestoreValues() {
    print("listening start");
    CollectionReference metaCollection =
        FirebaseFirestore.instance.collection('Meta');
    DocumentReference documentReference = metaCollection.doc('meta-data');

    documentReference.snapshots().listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        if (mounted) {
          setState(() {
            currentState = snapshot.get('current_state');
            print("current State is $currentState");
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    listenToFirestoreValues();
    // if (user != null) {
    //   WidgetsBinding.instance!.addPostFrameCallback((_) {
    //     Navigator.pushReplacement(
    //         context, MaterialPageRoute(builder: (context) => Homepage()));
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (currentState == "boarding") {
      return WaitingScreen();
    } else if (currentState == "gameplay") {
      return Homepage();
    } else {
      return ResultScreen();
    }
  }
}
