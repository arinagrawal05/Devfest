import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devfest/boarding.dart';
import 'package:devfest/functions.dart';
import 'package:devfest/google_sign.dart';
import 'package:devfest/result_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
import 'package:particles_flutter/particles_flutter.dart';

import 'homepage.dart';
import 'keyboard_listner.dart';
// import 'package:notes_app/function.dart';
// import 'package:notes_app/services/google_sign.dart';

// import '../style.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({super.key});

  @override
  _WaitingScreenState createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  User? user = FirebaseAuth.instance.currentUser;

  String currentState = "boarding";
  void listenToFirestoreValues() {
    print("listening start");
    CollectionReference metaCollection =
        FirebaseFirestore.instance.collection('Meta');
    DocumentReference documentReference = metaCollection.doc('meta-data');

    documentReference.snapshots().listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        // if (mounted) {
        //   setState(() {
        currentState = snapshot.get('current_state');
        print("current State is $currentState");
        if (snapshot.get('current_state') == "gameplay") {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Homepage()));
        }
        // });
        // }
      }
    });
  }

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (user == null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BoardingScreen()));
      });
    }
    // _audioPlayer = AudioPlayer();
    // if (user != null) {
    //   WidgetsBinding.instance!.addPostFrameCallback((_) {
    //     Navigator.pushReplacement(
    //         context, MaterialPageRoute(builder: (context) => Homepage()));
    //   });
    // }
  }

  Stream<int> listenToNumberOfDocuments() {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('Users');
    return usersCollection.snapshots().map((QuerySnapshot snapshot) {
      int numberOfDocuments = snapshot.size;

      return numberOfDocuments;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<ThemeProvider>(context, listen: true);
    // ThemeMode current = provider.getCurrentThemes();

    return Scaffold(
      backgroundColor: backgoundColor,
      key: _scaffoldKey,
      body: RawKeyboardListener(
        includeSemantics: true,
        autofocus: true,
        focusNode: _focusNode,
        onKey: (rawKeyEvent) {
          handleKeyEvent(rawKeyEvent, 0, context);
        },
        child: SingleChildScrollView(
          child: Stack(
            children: [
              CircularParticle(
                key: UniqueKey(),
                awayRadius: 80,
                numberOfParticles: 150,
                speedOfParticles: 1,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                onTapAnimation: true,
                particleColor: Colors.white.withAlpha(150),
                awayAnimationDuration: Duration(milliseconds: 600),
                maxParticleSize: 8,
                isRandSize: true,
                isRandomColor: true,
                randColorList: [
                  primaryTextColor.withOpacity(0.8),
                  primaryTextColor.withOpacity(0.6),
                  primaryTextColor.withOpacity(0.5),
                  primaryTextColor.withOpacity(0.4),
                  // Colors.white.withAlpha(210),
                  // Colors.yellow.withAlpha(210),
                  // Colors.green.withAlpha(210)
                ],
                awayAnimationCurve: Curves.easeInOutBack,
                enableHover: true,

                hoverColor: Colors.white,
                hoverRadius: 90,
                connectDots: false, //not recommended
              ),
              Opacity(
                opacity: 0.8,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Text(
                          "Game is starting soon",
                          style: GoogleFonts.rubikMoonrocks(
                              fontSize: 55, color: primaryTextColor),
                        ),
                        Text(
                          "Wait for your Host to Start the Game",
                          style: GoogleFonts.caveat(
                              fontSize: 25, color: secondaryTextColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<int>(
                      stream: listenToNumberOfDocuments(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        int documentCount = snapshot.data!;

                        return Center(
                          child: Text(
                            'Total users Entered: $documentCount',
                            style: GoogleFonts.caveat(
                                fontSize: 25, color: secondaryTextColor),
                          ),
                        );
                      }),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
