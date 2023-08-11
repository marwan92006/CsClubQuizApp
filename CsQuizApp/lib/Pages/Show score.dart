import 'package:csquizapp/UI%20components/submit%20button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class ShowScore extends StatefulWidget {
  final int score;
  final int totalQuestion;
  final String correctQuestion;
  final String attendantName;
  final String creator;
  final String quizId;

  const ShowScore(
      {super.key,
      required this.score,
      required this.totalQuestion,
      required this.correctQuestion,
      required this.attendantName,
      required this.quizId,
      required this.creator});

  @override
  State<ShowScore> createState() => _ShowScoreState();
}

class _ShowScoreState extends State<ShowScore> {
  bool showCorrectQuestions = false;
  @override
  void initState() {
   sendDetails();
    super.initState();
  }
  void sendDetails() {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    int currentHour = currentDate.hour;
    int currentMinute =currentDate.minute;
    int currentSeconds = currentDate.second;
    final user = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference refPrivate = FirebaseDatabase.instance.ref(
        "Private/User's quizzes/${widget.creator}/${widget.quizId}/Attendance/${randomAlphaNumeric(16)}");
    refPrivate.update({
        "Score": " ${widget.score} out of ${widget.totalQuestion}",
      "Name":widget.attendantName,
      "Uid": user,
      "Date": " $formattedDate hour $currentHour minute $currentMinute second $currentSeconds"
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      SvgPicture.asset(
        "lib/images/bg.svg",
        fit: BoxFit.fill,
      ),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your scored ${widget.score} out of ${widget.totalQuestion}",
              style: const TextStyle(color: Colors.white, fontSize: 30),
            ),
            const SizedBox(
              height: 20,
            ),
            SubmitButton(
              text: "View details",
              onpressed: (){
                setState(() {
                  showCorrectQuestions = true;
                });
              },
            ),
            const SizedBox(
              height: 60,
            ),
            showCorrectQuestions
                ? Text(
                    widget.correctQuestion,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    ]));
  }
}
