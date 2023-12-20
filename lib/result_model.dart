import 'package:cloud_firestore/cloud_firestore.dart';

class ResultData {
  String userId;
  String name;
  String userImage;
  int score;
  Timestamp timestamp;

  ResultData({
    required this.userId,
    required this.name,
    required this.userImage,
    required this.score,
    required this.timestamp,
  });

  factory ResultData.fromFirestore(DocumentSnapshot doc) {
    dynamic map = doc.data();
    return ResultData(
      userId: map['userid'] ?? '',
      name: map['name'] ?? '',
      userImage: map['userimg'] ?? '',
      score: map['score'] ?? 0,
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userId,
      'name': name,
      'userimg': userImage,
      'score': score,
      'timestamp': timestamp,
    };
  }
}
