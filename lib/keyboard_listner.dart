import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devfest/boarding.dart';
import 'package:devfest/data.dart';
import 'package:devfest/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<Tuple2<int, String>> handleKeyEvent(
    RawKeyEvent event, int questionNo, BuildContext context) async {
  if (event.logicalKey == LogicalKeyboardKey.shiftRight &&
      event is RawKeyDownEvent) {
    // Trigger the dialog box or perform any action here
    //  ;
    Tuple2<int, String> result =
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
  return Tuple2(3, "property");
}

Future<Tuple2<int, String>> panelDialog(BuildContext context,
    {int quesion = 0}) async {
  Completer<int> questioncompleter = Completer<int>();

  Completer<String> inputCompleter = Completer<String>();

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
              child: Column(
                children: [
                  Row(
                    children: [
                      quesion == 0
                          ? Container()
                          : ElevatedButton(
                              onPressed: () {
                                questioncompleter.complete(quesion - 1);
                                inputCompleter.complete("hello");
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
                                Navigator.of(context).pop();
                              },
                              child: Text("Previous Question")),
                      quesion + 1 == questionDataList.length
                          ? Container()
                          : ElevatedButton(
                              onPressed: () {
                                questioncompleter.complete(quesion + 1);
                                inputCompleter.complete("hello");
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
                                Navigator.of(context).pop();
                              },
                              child: Text("Next Question")),
                      ElevatedButton(
                          onPressed: () {
                            // questioncompleter.complete(quesion - 1);
                            // inputCompleter.complete("hello");

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResultScreen()));
                          },
                          child: Text("View result")),
                    ],
                  ),
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
  return Tuple2<int, String>(
    await questioncompleter.future,
    await inputCompleter.future,
  );
  // return actioncompleter.future;
}

class Tuple2<T1, T2> {
  final T1 questionNo;
  final T2 property;

  Tuple2(this.questionNo, this.property);
}

// actioncompleter.complete("add");
