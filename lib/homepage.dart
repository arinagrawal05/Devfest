import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devfest/google_sign.dart';
import 'package:devfest/reply_class.dart';
import 'package:devfest/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/observer.dart'

import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
import 'package:particles_flutter/particles_flutter.dart';

import 'data.dart';
import 'functions.dart';
import 'keyboard_listner.dart';
// import 'package:notes_app/function.dart';
// import 'package:notes_app/services/google_sign.dart';

// import '../style.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AudioPlayer _audioPlayer;
  User? user = FirebaseAuth.instance.currentUser;
  final ScrollController _scrollController = ScrollController();
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  final FocusNode _focusNode = FocusNode();

  // @override
  // void dispose() {
  //   _focusNode.dispose();
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();
    analytics.setAnalyticsCollectionEnabled(true);
    _audioPlayer = AudioPlayer();
  }

  int counter = 0;
  String lastquestionID = "";
  // String quesion
  QuestionData curentquestion = questionDataList[0];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: questionDataList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: signButton(questionDataList[index], lastquestionID),
                );
              },
            ),
          ),
        ],
      )),
      backgroundColor: backgoundColor,
      key: _scaffoldKey,
      body: RawKeyboardListener(
        includeSemantics: true,
        autofocus: true,
        focusNode: _focusNode,
        onKey: (rawKeyEvent) {
          handleKeyEvent(rawKeyEvent,
                  findIndex(curentquestion, questionDataList), context)
              .then((value) {
            // setState(() {
            curentquestion = questionDataList[value.questionNo];
            // });
          });
          // throw Exception('No return value');
        },
        child: Stack(
          children: [
            CircularParticle(
              key: UniqueKey(),
              awayRadius: 80,
              numberOfParticles: 150,
              speedOfParticles: 1,
              height: MediaQuery.of(context).size.height - 100,
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
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.7,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          children: [
                            // Center(
                            //   child: Text(
                            //     counter.toString() +
                            //         curentquestion.questionID +
                            //         ": " +
                            //         curentquestion.question,
                            //   ),
                            // ),

                            StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('Questions')
                                  .doc("currentquestion")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text('Error: ${snapshot.error}'),
                                  );
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (!snapshot.hasData ||
                                    !snapshot.data!.exists) {
                                  return Center(
                                    child: Text('Document does not exist'),
                                  );
                                }

                                // Access the data from the document
                                Map<String, dynamic> data = snapshot.data!
                                    .data() as Map<String, dynamic>;

                                // Display the data in a widget
                                return Text(
                                  'Q: ${data['question']}',
                                  style: GoogleFonts.gluten(
                                      fontSize: 28, color: secondaryTextColor),
                                );
                              },
                            ),

                            Container(
                              child: Expanded(
                                child: Container(
                                  margin: const EdgeInsets.all(6),
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                  ),
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection("chats")
                                        .orderBy("timestamp", descending: false)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container(); // Loading indicator
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else if (snapshot.hasData &&
                                          snapshot.data!.docs.isNotEmpty) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          _scrollController.animateTo(
                                            _scrollController
                                                .position.maxScrollExtent,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                        });

                                        return ListView.builder(
                                          controller: _scrollController,
                                          itemCount: snapshot.data!.docs.length,
                                          itemBuilder: (context, index) {
                                            // return Text("data");
                                            return replywidget(
                                              ReplyData.fromFirestore(
                                                  snapshot.data!.docs[index]),
                                            );
                                          },
                                        );
                                      } else {
                                        return const Text('No data available');
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void check(String givenAns, String newQid, String userid) {
    if (givenAns == curentquestion.answer) {
      if (curentquestion.questionID != lastquestionID) {
        setState(() {
          counter++;
          lastquestionID = curentquestion.questionID;
        });
        FirebaseFirestore.instance.collection("Result").doc(userid).update({
          "score": counter,
          "timestamp": DateTime.now(),
        }).then((value) {
          print("new score added");
        });
      } else {
        print("Answered Same Question Again");
      }
    } else {
      print("wrong answer");
    }
  }

  Widget signButton(QuestionData model, String questionID) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Container(
          height: 30,
          width: 50,
          child: NeoPopButton(
            animationDuration: const Duration(milliseconds: 250),
            color: Colors.grey.shade200,
            onTapUp: () {
              // FirebaseFirestore.instance
              //     .collection("Questions")
              //     .add(questionDataList[0].toMap())
              //     .then((value) {
              //   logButtonPress(analytics, model.answer);
              //   print(curentquestion.toMap().toString());
              //   check(model.answer, questionID,
              //       user != null ? user!.uid : "userid");
              //   scrollToBottom(_scrollController);
              // });
              FirebaseFirestore.instance.collection("chats").add({
                "userid": user != null ? user!.uid : "userid",
                "name": user != null ? user!.displayName : "username",
                "userimg": user != null
                    ? user!.photoURL
                    : "https://us.123rf.com/450wm/apoev/apoev1902/apoev190200141/125038134-personne-gris-espace-r%C3%A9serv%C3%A9-%C3%A0-la-photo-homme-en-costume-sur-fond-gris.jpg",
                "answer_img": model.answerImg,
                "answer_id": model.answer,
                "timestamp": DateTime.now(),
              }).then((value) {
                logButtonPress(analytics, model.answerImg);
                print(curentquestion.toMap().toString());
                check(model.answer, questionID,
                    user != null ? user!.uid : "userid");
                scrollToBottom(_scrollController);
              });
            },
            bottomShadowColor: Colors.grey.shade400,
            rightShadowColor: Colors.grey.shade400,
            onTapDown: () {
              playSoundEffect(_audioPlayer);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              child: Image.network(model.answerImg),
            ),
          ),
        ),
      ),
    );
  }
}

int findIndex(QuestionData search, List<QuestionData> stringList) {
  try {
    int index = stringList.indexOf(search);
    return index;
  } catch (e) {
    return -1; // Return -1 if the string is not found in the list
  }
}
