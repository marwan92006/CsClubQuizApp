import 'dart:async';

import 'package:csquizapp/Pages/Show%20score.dart';
import 'package:csquizapp/Pages/StartQuiz.dart';
import 'package:csquizapp/UI%20components/Display%20questions.dart';
import 'package:csquizapp/UI%20components/submit%20button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DisplayQuestion extends StatefulWidget {
  final String quizId;
  final String attendantName;
  final String creator;
  const DisplayQuestion(
      {super.key, required this.quizId, required this.attendantName, required this.creator});

  @override
  State<DisplayQuestion> createState() => _DisplayQuestionState();
}

class _DisplayQuestionState extends State<DisplayQuestion> {
  String question = "";
  String choiceOne = "";
  String choiceTwo = "";
  String choiceThree = "";
  String choiceFour = "";
  String image = "";
  String correctQuestions = "Correct questions: ";
  bool showNextQuestionButton = true;
  bool showPreviousQuestionButton = true;
  bool isAnswered = false;
  bool showQuestionTracker = false;
  bool showImage = false;
  int questionNumber = 1;
  int numberOfQuestions = 1;
  int correctOption = 0;
  int correctAnswersCounter = 0;
  int _secondsRemaining = 0;
  int duration = 0;
  late Timer _timer;
  final ref = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    const StartQuiz();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: (10)), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
          nextQuestion();
        }
      });
    });
  }

  void showSnackbarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> nextQuestion() async {
    final snapshotN = await ref
        .child("Public/Public quizzes/${widget.quizId}/Number of questions")
        .get();
    numberOfQuestions = snapshotN.value as int;
    if (numberOfQuestions > questionNumber) {
      setState(() {
        questionNumber++;
      });
    } else if (numberOfQuestions == questionNumber) {
      finishQuiz();
    }

    final snapshotQ = await ref
        .child(
            "Public/Public quizzes/${widget.quizId}/Question $questionNumber")
        .get();
    final snapshotA = await ref
        .child(
            "Public/Public quizzes/${widget.quizId}/Choices $questionNumber/Option 1")
        .get();
    final snapshotB = await ref
        .child(
            "Public/Public quizzes/${widget.quizId}/Choices $questionNumber/Option 2")
        .get();
    final snapshotC = await ref
        .child(
            "Public/Public quizzes/${widget.quizId}/Choices $questionNumber/Option 3")
        .get();
    final snapshotD = await ref
        .child(
            "Public/Public quizzes/${widget.quizId}/Choices $questionNumber/Option 4")
        .get();
    final snapshotI = await ref
        .child(
            "Public/Public quizzes/${widget.quizId}/Choices $questionNumber/ImageUrl")
        .get();
    final snapshotT = await ref
        .child(
            "Public/Public quizzes/${widget.quizId}/Choices $questionNumber/Duration")
        .get();
    setState(() {
      question = snapshotQ.value.toString();
      choiceOne = snapshotA.value.toString();
      choiceTwo = snapshotB.value.toString();
      choiceThree = snapshotC.value.toString();
      choiceFour = snapshotD.value.toString();
      image = snapshotI.value.toString();
      _secondsRemaining = (snapshotT.value as int) * 100;
      duration = (snapshotT.value as int) * 100;
    });
    if (image == "") {
      setState(() {
        showImage = false;
      });
    } else {
      setState(() {
        showImage = true;
      });
    }
    startTimer();
  }

  Future<void> startQuiz() async {
    final snapshotN = await ref
        .child("Public/Public quizzes/${widget.quizId}/Number of questions")
        .get();
    final snapshotQ = await ref
        .child(
            "Public/Public quizzes/${widget.quizId}/Question $questionNumber")
        .get();
    final snapshotA = await ref
        .child(
            "Public/Public quizzes/${widget.quizId}/Choices $questionNumber/Option 1")
        .get();
    final snapshotB = await ref
        .child(
            "Public/Public quizzes/${widget.quizId}/Choices $questionNumber/Option 2")
        .get();
    final snapshotC = await ref
        .child(
            "Public/Public quizzes/${widget.quizId}/Choices $questionNumber/Option 3")
        .get();
    final snapshotD = await ref
        .child(
            "Public/Public quizzes/${widget.quizId}/Choices $questionNumber/Option 4")
        .get();
    final snapshotI = await ref
        .child(
            "Public/Public quizzes/${widget.quizId}/Choices $questionNumber/ImageUrl")
        .get();
    final snapshotT = await ref
        .child(
            "Public/Public quizzes/${widget.quizId}/Choices $questionNumber/Duration")
        .get();
    setState(() {
      choiceOne = snapshotA.value.toString();
      choiceTwo = snapshotB.value.toString();
      choiceThree = snapshotC.value.toString();
      choiceFour = snapshotD.value.toString();
      question = snapshotQ.value.toString();
      image = snapshotI.value.toString();
      numberOfQuestions = snapshotN.value as int;
      _secondsRemaining = (snapshotT.value as int) * 100;
      duration = (snapshotT.value as int) * 100;
      showNextQuestionButton = false;
      showQuestionTracker = true;
    });
    if (image == "") {
      setState(() {
        showImage = false;
      });
    } else {
      setState(() {
        showImage = true;
      });
    }
    startTimer();
  }

  optionCheck(int index) async {
    final snapshotR = await ref
        .child(
            "Public/Public quizzes/${widget.quizId}/Choices $questionNumber/CorrectAnswerIndex")
        .get();
    correctOption = snapshotR.value as int;
    if (index == correctOption) {
      correctAnswersCounter++;
      correctQuestions += "$questionNumber,";
      nextQuestion();
    } else if (index != correctOption) {
      nextQuestion();
    }
  }

  void finishQuiz() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ShowScore(

              score: correctAnswersCounter,
              totalQuestion: numberOfQuestions,
              correctQuestion: correctQuestions, attendantName: widget.attendantName, quizId: widget.quizId, creator: widget.creator,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      SvgPicture.asset(
        "lib/images/bg.svg",
        fit: BoxFit.fill,
        height: 1080,
        width: 1920,
      ),
      Center(
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              showNextQuestionButton
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: double.infinity,
                        height: 35,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xFF3F4768), width: 3),
                            borderRadius: BorderRadius.circular(50)),
                        child: Stack(
                          children: [
                            LayoutBuilder(
                              builder: (context, constraints) => Padding(
                                padding: const EdgeInsets.all(1.8),
                                child: Container(
                                  width: constraints.maxWidth *
                                      (duration - _secondsRemaining) *
                                      (1 / duration),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xFF46ABAE),
                                          Color(0xFF0BFFCB)
                                        ]),
                                    borderRadius: BorderRadius.circular(
                                        50), // LinearGradient
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${(_secondsRemaining / 100).round()} sec",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.timer_outlined,
                                    color: Colors.white70,
                                  )
                                ],
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: showNextQuestionButton
                    ? const SizedBox()
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            question,
                            style: const TextStyle(
                                fontSize: 24, color: Colors.black54),
                          ),
                        ),
                      ),
              ),
              const SizedBox(
                height: 30,
              ),
              showImage
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Image.network(
                        image,
                        fit: BoxFit.fill,
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      showNextQuestionButton
                          ? const SizedBox()
                          : QuestionDisplay(
                              onTap: () {
                                optionCheck(1);
                              },
                              text: choiceOne,
                              color: Colors.red[900],
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      showNextQuestionButton
                          ? const SizedBox()
                          : QuestionDisplay(
                              onTap: () {
                                optionCheck(2);
                              },
                              text: choiceTwo,
                              color: Colors.blue[900],
                            ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      showNextQuestionButton
                          ? const SizedBox()
                          : QuestionDisplay(
                              onTap: () {
                                optionCheck(3);
                              },
                              text: choiceThree,
                              color: Colors.yellow[900],
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      showNextQuestionButton
                          ? const SizedBox()
                          : QuestionDisplay(
                              onTap: () {
                                optionCheck(4);
                              },
                              text: choiceFour,
                              color: Colors.green[900],
                            ),
                    ],
                  ),
                ],
              ),
              showNextQuestionButton
                  ? SubmitButton(
                      text: "Start",
                      onpressed: startQuiz,
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 20,
              ),
              showQuestionTracker
                  ? Text(
                      "$questionNumber out of  $numberOfQuestions",
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 20,
              ),
              showNextQuestionButton
                  ? const SizedBox()
                  : SubmitButton(
                      text: "Finish",
                      onpressed: finishQuiz,
                    ),
            ],
          ),
        )),
      )
    ]));
  }
}
