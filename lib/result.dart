import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devfest/functions.dart';
import 'package:devfest/result_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:particles_flutter/particles_flutter.dart';

import 'keyboard_listner.dart';
// import 'package:notes_app/function.dart';
// import 'package:notes_app/services/google_sign.dart';

// import '../style.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AudioPlayer _audioPlayer;
  User? user = FirebaseAuth.instance.currentUser;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    // if (user != null) {
    //   WidgetsBinding.instance!.addPostFrameCallback((_) {
    //     Navigator.pushReplacement(
    //         context, MaterialPageRoute(builder: (context) => Homepage()));
    //   });
    // }
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
                child: Column(
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
                              "Results Out!",
                              style: GoogleFonts.rubikMoonrocks(
                                  fontSize: 55, color: primaryTextColor),
                            ),
                            Text(
                              "Your Name will be highlighted",
                              style: GoogleFonts.caveat(
                                  fontSize: 25, color: secondaryTextColor),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("Result")
                            .orderBy("score", descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(); // Loading indicator
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData &&
                              snapshot.data!.docs.isNotEmpty) {
                            return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                // return Text("data");
                                return resultTile(
                                    ResultData.fromFirestore(
                                      snapshot.data!.docs[index],
                                    ),
                                    index + 1);
                              },
                            );
                          } else {
                            return const Text('No data available');
                          }
                        },
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget resultTile(ResultData data, int index) {
    String userid = user != null ? user!.uid : "userid";
    return Container(
      color:
          userid == data.userId ? Colors.yellowAccent.shade100 : Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                index.toString() + ".    ",
                style: GoogleFonts.bangers(fontSize: 21),
              ),
              CircleAvatar(
                backgroundImage: NetworkImage(data.userImage),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                data.name,
                style: GoogleFonts.montserrat(fontSize: 19),
              ),
            ],
          ),
          Text(
            data.score.toString() + " Points",
            style: GoogleFonts.montserrat(fontSize: 19),
          ),
        ],
      ),
    );
  }
}
