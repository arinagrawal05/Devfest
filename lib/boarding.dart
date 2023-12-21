import 'package:devfest/google_sign.dart';
import 'package:devfest/waiting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';

import 'functions.dart';
// import 'package:notes_app/function.dart';
// import 'package:notes_app/services/google_sign.dart';

// import '../style.dart';

class BoardingScreen extends StatefulWidget {
  const BoardingScreen({super.key});

  @override
  _BoardingScreenState createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AudioPlayer _audioPlayer;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WaitingScreen()));
      });
    }
  }

  Future<void> _playSoundEffect() async {
    // Provide the path to your sound effect file
    String soundPath = "assets/sound.wav"; // Update with your actual file path

    try {
      // Load and play the audio
      await _audioPlayer.setAsset(soundPath);
      await _audioPlayer.play();
      print("Sound effect played successfully");
    } catch (e) {
      print("Error playing sound effect: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<ThemeProvider>(context, listen: true);
    // ThemeMode current = provider.getCurrentThemes();
    double wid = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgoundColor,
      key: _scaffoldKey,
      body: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(15.0),
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(15),
            //     child: Container(
            //       width: MediaQuery.of(context).size.width,
            //       // height: 400,
            //       child: Image.network(
            //         "https://res.cloudinary.com/startup-grind/image/upload/c_fill,dpr_2.0,f_auto,g_center,h_360,q_100,w_1140/v1/gcs/platform-data-goog/chapter_banners/Copy%20of%20DF23-GoogleSites-Banner-Yellow.jpg",
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Text(
                    "Logo Challenge",
                    style: GoogleFonts.rubikMoonrocks(
                        fontSize: 55, color: primaryTextColor),
                  ),
                  Text(
                    "Let's Test your Tech Logo Knowledge",
                    style: GoogleFonts.caveat(
                        fontSize: 25, color: secondaryTextColor),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // Center(
            //   child: Text(
            //     "Ready to Play?",
            //     style: GoogleFonts.montserrat(fontSize: 30),
            //   ),
            // ),
            const SizedBox(
              height: 20,
            ),
            signButton(context),
            Spacer(),
            wid <= 380
                ? Container(
                    width: double.infinity,
                    // constraints: BoxConstraints(
                    //     maxHeight: MediaQuery.of(context).size.height * 0.3),
                    child: Image.network(
                      "https://i.pinimg.com/originals/88/aa/8b/88aa8bd71cf42123aabe7030cdea7056.gif",
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(),
          ]),
    );
  }

  Widget signButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: NeoPopButton(
        animationDuration: Duration(milliseconds: 250),
        color: Colors.grey.shade100,
        onTapUp: () {
          AuthMethods().signInWithGoogle(context);
        },
        bottomShadowColor: Colors.grey.shade400,
        rightShadowColor: Colors.grey.shade400,
        onTapDown: () {
          _playSoundEffect();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              SizedBox(
                height: 30,
                width: 30,
                child: Image.asset("assets/google_logo.png"),
              ),
              const SizedBox(
                width: 13,
              ),
              Text(
                "Continue With Google",
                style: GoogleFonts.montserrat(fontSize: 19),
              )
            ],
          ),
        ),
      ),
    );
  }
}
