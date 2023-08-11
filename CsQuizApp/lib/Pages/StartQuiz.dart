import 'package:csquizapp/Pages/Display%20questions.dart';
import 'package:csquizapp/UI%20components/Text%20field.dart';
import 'package:csquizapp/UI%20components/submit%20button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StartQuiz extends StatefulWidget {
  const StartQuiz({super.key});

  @override
  State<StartQuiz> createState() => _StartQuizState();
}

class _StartQuizState extends State<StartQuiz> {
  void showSnackbarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  final ref = FirebaseDatabase.instance.ref();

  Future<void> readDataAndSetAttendedName() async {
    if (quizIdController.text.isEmpty) {
      showSnackbarMessage(context, "Please fill the quiz Id field");
    }
    else if (attendedNameController.text.isEmpty){
      showSnackbarMessage(context, "Please fill the name field");
    }
    else {
      final snapshotQ = await ref
          .child("Public/Public quizzes/${quizIdController.text.toString()}")
          .get();
      final snapshotC = await ref
          .child("Public/Public quizzes/${quizIdController.text.toString()}/Creator")
          .get();
      if (snapshotQ.exists &&
          attendedNameController.text.toString().isNotEmpty) {
        String creator = snapshotC.value.toString();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => DisplayQuestion(
                  quizId: quizIdController.text.toString(),
                  attendantName: attendedNameController.text.toString(), creator: creator,
                )));
      } else {
        showSnackbarMessage(
            context, "Quiz doesn't exist");
      }
    }
  }

  final quizIdController = TextEditingController();
  final attendedNameController = TextEditingController();

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Textfield(
              controller: attendedNameController,
              hintText: "Name",
              obscureText: false,
            ),
            const SizedBox(
              height: 20,
            ),
            Textfield(
              controller: quizIdController,
              hintText: "Enter the quiz Id",
              obscureText: false,
            ),
            const SizedBox(
              height: 20,
            ),
            SubmitButton(
              text: "Proceed",
              onpressed: readDataAndSetAttendedName,
            ),
          ],
        ),
      ),
    ]));
  }
}
