import 'package:csquizapp/Pages/Attendance.dart';
import 'package:csquizapp/UI%20components/submit%20button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AttendanceOrQuizId extends StatefulWidget {
  final String quizId;

  const AttendanceOrQuizId({super.key, required this.quizId});

  @override
  State<AttendanceOrQuizId> createState() => _AttendanceOrQuizIdState();
}

class _AttendanceOrQuizIdState extends State<AttendanceOrQuizId> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Cs Club Quiz App",
          ),
          leading: Image.asset("lib/images/official-logo.png"),
          backgroundColor: const Color(0xff252C4A)),
      body: Stack(
        children: [
          SvgPicture.asset(
            "lib/images/bg.svg",
            fit: BoxFit.fill,
          ),
          SafeArea(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SelectableText(
                  "Your quiz Id :${widget.quizId}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SubmitButton(
                  text: "View quiz attendance",
                  onpressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Attendance(quizId: widget.quizId)));
                  },
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
