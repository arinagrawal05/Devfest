import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devfest/boarding.dart';
import 'package:devfest/reply_class.dart';
import 'package:devfest/stopwatch.dart';
import 'package:devfest/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  late AudioPlayer _audioPlayer2;
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
    if (user == null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const BoardingScreen()));
      });
    }
    mywatch.start();
    listenToFirestoreValues();
    analytics.setAnalyticsCollectionEnabled(true);
    _audioPlayer = AudioPlayer();
    _audioPlayer2 = AudioPlayer();
    FirebaseFirestore.instance.collection("Meta").doc("meta-data").update({
      'last_question_time': Timestamp.now(),
    });
    FirebaseFirestore.instance
        .collection("Questions")
        .doc("currentquestion")
        .update(questionDataList[0].toMap());
    listenToquestionChange();
  }

  bool isSoundEnabled = false;
  void listenToFirestoreValues() {
    print("listening start");
    CollectionReference metaCollection =
        FirebaseFirestore.instance.collection('Meta');
    DocumentReference documentReference = metaCollection.doc('meta-data');
    documentReference.snapshots().listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        isSoundEnabled = snapshot.get('isSound');
        lastquestionTime = snapshot.get('last_question_time');
        print(
            "Listened New data Where Sound is $isSoundEnabled Last Time is${lastquestionTime.toDate()}");
        if (isSoundEnabled) {
          playBackgroundSoundEffect(_audioPlayer2);
        } else {
          _audioPlayer2.stop();
        }
      }
    });
  }

  void listenToquestionChange() {
    print("question listening start");
    CollectionReference metaCollection =
        FirebaseFirestore.instance.collection('Questions');
    DocumentReference documentReference = metaCollection.doc('currentquestion');
    documentReference.snapshots().listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        print("this changes ssssssssssssssssssssssssssssssssssssss");

        mywatch.start();
        mywatch.reset();
        // curentquestion
        curentquestion = QuestionData.fromFirestore(snapshot);
        // curentquestion = QuestionData(
        //     snapshot.get('question'),
        //     snapshot.get('questionID'),
        //     snapshot.get('answerID'),
        //     snapshot.get('answer'));

        // isSoundEnabled = snapshot.get('isSound');
        // lastquestionTime = snapshot.get('last_question_time');
        print("new question" + curentquestion.toMap().toString());
        print("old question" + questionDataList[0].toMap().toString());
        if (isSoundEnabled) {
          playBackgroundSoundEffect(_audioPlayer2);
        } else {
          _audioPlayer2.stop();
        }
      }
    });
  }

  List<QuestionData> shuffleList(List<QuestionData> list) {
    final Random random = Random();
    List<QuestionData> shuffledList = List.from(list);

    for (int i = shuffledList.length - 1; i > 0; i--) {
      int randIndex = random.nextInt(i + 1);

      // Swap elements at i and randIndex
      QuestionData temp = shuffledList[i];
      shuffledList[i] = shuffledList[randIndex];
      shuffledList[randIndex] = temp;
    }

    return shuffledList;
  }

  Stopwatch mywatch = Stopwatch();
  int counter = 0;
  String lastquestionID = "";
  Timestamp lastquestionTime = Timestamp.now();
  QuestionData curentquestion = questionDataList[0];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgoundColor,
      key: _scaffoldKey,
      body: RawKeyboardListener(
        includeSemantics: true,
        autofocus: true,
        focusNode: _focusNode,
        onKey: (rawKeyEvent) {
          handleKeyEvent(rawKeyEvent,
              findIndex(curentquestion, questionDataList), context);

          //     .then((value) {
          //   // mywatch.start();
          //   // mywatch.reset();

          //   // curentquestion = questionDataList[value.questionNo];
          // });
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
              awayAnimationDuration: const Duration(milliseconds: 600),
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
                      MyStopwatch(stopwatch: mywatch),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.65,
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
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (!snapshot.hasData ||
                                    !snapshot.data!.exists) {
                                  return const Center(
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
                      Spacer(),
                      Container(
                        width: 300,
                        // height: 150,
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, // Number of columns
                            crossAxisSpacing: 2.0, // Spacing between columns
                            mainAxisSpacing: 2.0, // Spacing between rows
                          ),
                          itemCount: questionDataList
                              .length, // Total number of items in the grid
                          itemBuilder: (context, index) {
                            // Build each grid item
                            return iconButton(
                                questionDataList[index], lastquestionID);
                          },
                        ),
                      )
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void check(
    String givenAns,
    String newQid,
    String userid,
    DateTime lastquestion,
  ) {
    if (givenAns == curentquestion.answer) {
      int scoreParameter =
          DateTime.now().difference(lastquestionTime.toDate()).inSeconds;
      int newscore = 100 - (scoreParameter * 3);
      print("$scoreParameter Seconds User has Taken");
      if (curentquestion.questionID != lastquestionID) {
        // mywatch.stop();

        counter += newscore;
        lastquestionID = curentquestion.questionID;

        playBonusSoundEffect(_audioPlayer);
        showSnackBar(context,
            "Hurray! You took $scoreParameter secs 🎉\n$newscore Points added!");
        FirebaseFirestore.instance.collection("Result").doc(userid).update({
          "score": counter,
          "timestamp": DateTime.now(),
        }).then((value) {});
      } else {
        print("Answered Same Question Again");
      }
    } else {
      print("wrong answer");
    }
  }

  Widget iconButton(QuestionData model, String questionID) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Container(
          height: 30,
          width: 50,
          child: NeoPopButton(
            animationDuration: const Duration(milliseconds: 250),
            color: Colors.grey.shade200,
            onTapUp: () {
              // int scoreParameter =
              //     DateTime.now().difference(lastquestionTime).inSeconds;
              // for (var i = 0; i < 10; i++) {
              //   Timer(Duration(seconds: 2), () {
              //     print(scoreParameter);
              //   });
              // }
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
                check(
                    model.answer,
                    questionID,
                    user != null ? user!.uid : "userid",
                    lastquestionTime.toDate());
                // scrollToBottom(_scrollController);
              });
            },
            bottomShadowColor: Colors.grey.shade400,
            rightShadowColor: Colors.grey.shade400,
            onTapDown: () {
              playButtonSoundEffect(_audioPlayer);
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

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  int findIndex(QuestionData search, List<QuestionData> stringList) {
    try {
      int index = stringList.indexOf(search);
      return index;
    } catch (e) {
      return -1; // Return -1 if the string is not found in the list
    }
  }
}
