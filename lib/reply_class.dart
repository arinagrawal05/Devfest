import 'package:cloud_firestore/cloud_firestore.dart';

class ReplyData {
  String userid;
  String name;
  String userImage;
  String answerImage;
  String answerId;
  Timestamp timestamp;

  ReplyData({
    required this.userid,
    required this.name,
    required this.userImage,
    required this.answerImage,
    required this.answerId,
    required this.timestamp,
  });

  factory ReplyData.fromFirestore(DocumentSnapshot doc) {
    dynamic map = doc.data();

    return ReplyData(
      userid: map['userid'] ?? '',
      name: map['name'] ?? '',
      userImage: map['userimg'] ?? '',
      answerImage: map['answer_img'] ?? '',
      answerId: map['answer_id'] ?? 0,
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userid': userid,
      'name': name,
      'userimg': userImage,
      'answer_img': answerImage,
      'answer_id': answerId,
      'timestamp': timestamp,
    };
  }
}
