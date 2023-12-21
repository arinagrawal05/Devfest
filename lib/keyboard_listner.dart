import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devfest/boarding.dart';
import 'package:devfest/data.dart';
import 'package:devfest/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<Tuple2<int, DateTime>> handleKeyEvent(
    RawKeyEvent event, int questionNo, BuildContext context) async {
  if (event.logicalKey == LogicalKeyboardKey.shiftRight &&
      event is RawKeyDownEvent) {
    // Trigger the dialog box or perform any action here
    //  ;
    Tuple2<int, DateTime> result =
        await panelDialog(context, quesion: questionNo);
    // if (result.questionNo == "delete") {
    //   setState(() {
    //     stackData.remove(item);
    //   });
    // } else if (result.action == "edit") {
    //   setState(() {
    //     stackData.remove(item);
    //     stackData
    //         .add(convertJsonToTextProperties(jsonStringToMap(result.property)));
    //   });
    // }
    return result;
  }
  return Tuple2(3, DateTime.now());
}

Future<Tuple2<int, DateTime>> panelDialog(BuildContext context,
    {int quesion = 0}) async {
  Completer<int> questioncompleter = Completer<int>();

  Completer<DateTime> inputCompleter = Completer<DateTime>();

  // TextEditingController controller =
  //     TextEditingController(text: properties.text);

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        // title: const Text('Edit Font Properties'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
                child: Container(
              height: 400,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Current Question:" + (quesion + 1).toString()),
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.close))
                    ],
                  ),
                  Row(
                    children: [
                      quesion == 0
                          ? Container()
                          : ElevatedButton(
                              onPressed: () {
                                questioncompleter.complete(quesion - 1);
                                inputCompleter.complete(DateTime.now());
                                FirebaseFirestore.instance
                                    .collection("Questions")
                                    .doc("currentquestion")
                                    .update({
                                  'question':
                                      questionDataList[quesion - 1].question,
                                  'questionID':
                                      questionDataList[quesion - 1].questionID,
                                  'answer':
                                      questionDataList[quesion - 1].answerImg,
                                  'answerID':
                                      questionDataList[quesion - 1].answer,
                                });
                                FirebaseFirestore.instance
                                    .collection("Meta")
                                    .doc("meta-data")
                                    .update({
                                  'last_question_time': Timestamp.now(),
                                });
                                Navigator.of(context).pop();
                              },
                              child: const Text("Previous Question")),
                      quesion + 1 == questionDataList.length
                          ? Container()
                          : ElevatedButton(
                              onPressed: () {
                                questioncompleter.complete(quesion + 1);
                                inputCompleter.complete(DateTime.now());
                                FirebaseFirestore.instance
                                    .collection("Questions")
                                    .doc("currentquestion")
                                    .update({
                                  'question':
                                      questionDataList[quesion + 1].question,
                                  'questionID':
                                      questionDataList[quesion + 1].questionID,
                                  'answer':
                                      questionDataList[quesion + 1].answerImg,
                                  'answerID':
                                      questionDataList[quesion + 1].answer,
                                });
                                FirebaseFirestore.instance
                                    .collection("Meta")
                                    .doc("meta-data")
                                    .update({
                                  'last_question_time': Timestamp.now(),
                                });
                                Navigator.of(context).pop();
                              },
                              child: const Text("Next Question")),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("Meta")
                            .doc("meta-data")
                            .update({
                          'current_state': "boarding",
                        }).then((value) {
                          Navigator.pop(context);
                        });
                      },
                      child: const Text("Restart Game")),
                  ElevatedButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("Meta")
                            .doc("meta-data")
                            .update({
                          'current_state': "gameplay",
                        }).then((value) {
                          Navigator.pop(context);
                        });
                      },
                      child: const Text("Begin Game")),
                  ElevatedButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("Meta")
                            .doc("meta-data")
                            .update({
                          'current_state': "result",
                        }).then((value) {
                          Navigator.pop(context);
                        });
                      },
                      child: const Text("View result")),
                ],
              ),
            ));
          },
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        // actionsPadding: const EdgeInsets.all(30),
      );
    },
  );
  return Tuple2<int, DateTime>(
    await questioncompleter.future,
    await inputCompleter.future,
  );
  // return actioncompleter.future;
}

class Tuple2<T1, T2> {
  final T1 questionNo;
  final T2 lastTime;

  Tuple2(this.questionNo, this.lastTime);
}

// actioncompleter.complete("add");
