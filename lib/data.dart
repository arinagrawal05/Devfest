import 'homepage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionData {
  String question;
  String questionID;
  String answer;
  String answerImg;

  QuestionData(
    this.question,
    this.questionID,
    this.answer,
    this.answerImg,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionData &&
          runtimeType == other.runtimeType &&
          question == other.question &&
          questionID == other.questionID &&
          answer == other.answer &&
          answerImg == other.answerImg;

  @override
  int get hashCode =>
      question.hashCode ^
      questionID.hashCode ^
      answer.hashCode ^
      answerImg.hashCode;

  factory QuestionData.fromFirestore(DocumentSnapshot doc) {
    dynamic map = doc.data();

    return QuestionData(
      map['question'] ?? '',
      map['questionID'] ?? '',
      map['answerID'] ?? '',
      map['answer'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'questionID': questionID,
      'answer': answerImg,
      'answerID': answer,
    };
  }
}

List<QuestionData> questionDataList = [
  QuestionData("Which is flutter logo", "q1", "flutter",
      "https://firebasestorage.googleapis.com/v0/b/devfest-c0b36.appspot.com/o/Logos%2FFlutter.png?alt=media&token=7ad8a062-57e0-4a42-94dc-f9c92a06affd"),
  QuestionData("Which is react logo", "q2", "react",
      "https://firebasestorage.googleapis.com/v0/b/devfest-c0b36.appspot.com/o/Logos%2FReact.png?alt=media&token=67749021-f8d5-42a6-be3d-6fdf764c6612"),
  QuestionData("Which is angular logo", "q3", "angular",
      "https://firebasestorage.googleapis.com/v0/b/devfest-c0b36.appspot.com/o/Logos%2FAngular.png?alt=media&token=bbf3efe8-8398-47f4-b1a3-1c1af4af8ede"),
  QuestionData("Which is firebase logo", "q4", "firebase",
      "https://firebasestorage.googleapis.com/v0/b/devfest-c0b36.appspot.com/o/Logos%2FFirebase.png?alt=media&token=f61b4111-a992-463d-9cf5-ca5fa70e6a4c"),
  QuestionData("Which is dart logo", "q5", "dart",
      "https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/dart-programming-language-icon.png"),
  QuestionData("Which is swift logo", "q6", "swift",
      "https://firebasestorage.googleapis.com/v0/b/devfest-c0b36.appspot.com/o/Logos%2FSwift.png?alt=media&token=3b3a50b1-e3e1-4166-89dc-1d47dc58a6e7"),
  QuestionData("Which is Android logo", "q7", "android",
      "https://firebasestorage.googleapis.com/v0/b/devfest-c0b36.appspot.com/o/Logos%2Fandroid.png?alt=media&token=4a4bdcdf-3919-45ce-b654-c87cc3c7f8f7"),
  QuestionData("Which is Tensorflow logo", "q8", "tensorflow",
      "https://firebasestorage.googleapis.com/v0/b/devfest-c0b36.appspot.com/o/Logos%2Ftensorflow.png?alt=media&token=818c6637-3666-42b6-8342-4b98207093ac"),
];
