import 'package:csquizapp/Pages/AddQuestion.dart';
import 'package:csquizapp/UI%20components/submit%20button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:random_string/random_string.dart';

import '../UI components/Text field.dart';

class CreateQuiz extends StatefulWidget {
  const CreateQuiz({super.key});

  @override
  State<CreateQuiz> createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final quizImageUrlController = TextEditingController();
  final quizTitleController = TextEditingController();
  final quizDescriptionController = TextEditingController();
  final String quizId = randomAlphaNumeric(16);
  final User? user = FirebaseAuth.instance.currentUser!;

  createQuizOnline() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    if (quizTitleController.text.isEmpty) {
      showSnackbarMessage(context, "Quiz title is required");
      Navigator.pop(context);
    } else if (quizDescriptionController.text.isEmpty) {
      showSnackbarMessage(context, "Quiz Description is required");
      Navigator.pop(context);
    } else {
      DatabaseReference refPublic =
          FirebaseDatabase.instance.ref("Public/Public quizzes/$quizId");
      DatabaseReference refPrivate = FirebaseDatabase.instance
          .ref("Private/User's quizzes/${user?.uid}/$quizId");
      await refPublic.set({
        "QuizTitle": quizTitleController.text.toString(),
        "QuizDescription": quizDescriptionController.text.toString(),
      });
      await refPrivate.set({
        "QuizId": quizId,
        "QuizTitle": quizTitleController.text.toString(),
        "QuizDescription": quizDescriptionController.text.toString(),
      });
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => AddQuestions(
                quizId: quizId,
                quizTitle: quizTitleController.text.toString(),
                quizDescription: quizDescriptionController.text.toString(),
              )));
    }
  }

  void showSnackbarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(
            seconds: 2), // Optional: Set the duration to display the snackbar
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              "Cs Club Quiz App",
            ),
            leading: Image.asset("lib/images/official-logo.png"),
            backgroundColor: const Color(0xff252C4A)),
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
                  const SizedBox(
                    height: 20,
                  ),
                  Textfield(
                    controller: quizTitleController,
                    obscureText: false,
                    hintText: "Quiz title",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Textfield(
                    controller: quizDescriptionController,
                    obscureText: false,
                    hintText: "Quiz description",
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SubmitButton(
                    onpressed: createQuizOnline,
                    text: "Create quiz online",
                  )
                ],
              ),
            )),
          ),
        ]));
  }
}
