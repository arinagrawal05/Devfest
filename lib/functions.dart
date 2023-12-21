import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devfest/homepage.dart';
import 'package:devfest/waiting.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

const Color backgoundColor = Color.fromRGBO(227, 222, 216, 1);
const Color primaryTextColor = Color.fromRGBO(175, 141, 105, 1);

const Color secondaryTextColor = Color.fromRGBO(63, 66, 67, 1);

userAddToFirebase(User userDetails, BuildContext context) {
  FirebaseFirestore.instance
      .collection("Users")
      .where("userid", isEqualTo: userDetails.uid)
      .get()
      .then((value) {
    if (value.docs.isEmpty) {
      FirebaseFirestore.instance.collection("Users").doc(userDetails.uid).set({
        "name": userDetails.displayName ?? "",
        "email": userDetails.email ?? "",
        "phone": userDetails.phoneNumber ?? "",
        "userimg": userDetails.photoURL ?? "",
        "userid": userDetails.uid,
        "timestamp": DateTime.now(),
      }).then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Homepage()));
        print("All Data is Saved To Firebase!!");
      });
      FirebaseFirestore.instance.collection("Result").doc(userDetails.uid).set({
        "userid": userDetails.uid,
        "name": userDetails.displayName ?? "",
        "userimg": userDetails.photoURL ?? "",
        "score": 0,
        "timestamp": DateTime.now(),
      }).then((value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const WaitingScreen()));
        if (kDebugMode) {
          print("All Data is Saved To Firebase!!");
        }
      });
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const WaitingScreen()));
      if (kDebugMode) {
        print("this is existing user");
      }
    }
  });
}

void logButtonPress(FirebaseAnalytics analytics, String page) {
  analytics.logEvent(
    name: 'button_press',
    parameters: <String, dynamic>{'page': page},
  ).then((value) {
    if (kDebugMode) {
      print("Analytics Recorded");
    }
  });
}

Future<void> playButtonSoundEffect(AudioPlayer audioPlayer) async {
  String soundPath = "assets/sound.wav";
  try {
    await audioPlayer.setAsset(soundPath);
    await audioPlayer.play();
    if (kDebugMode) {
      print("Sound effect played successfully");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error playing sound effect: $e");
    }
  }
}

Future<void> playBonusSoundEffect(AudioPlayer audioPlayer) async {
  String soundPath = "assets/bonus.wav";
  try {
    await audioPlayer.setAsset(soundPath);
    await audioPlayer.play();
    if (kDebugMode) {
      print("Sound effect played successfully");
    }
  } catch (e) {
    print("Error playing sound effect: $e");
  }
}

Future<void> playBackgroundSoundEffect(AudioPlayer audioPlayer) async {
  audioPlayer.setLoopMode(LoopMode.one);
  String soundPath = "assets/background.wav";
  try {
    await audioPlayer.setAsset(soundPath);
    await audioPlayer.play();
    print("Sound effect played successfully");
  } catch (e) {
    print("Error playing sound effect: $e");
  }
}
