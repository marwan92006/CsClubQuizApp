import 'package:csquizapp/Pages/Display%20questions.dart';
import 'package:csquizapp/UI%20components/submit%20button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditOrStartQuiz extends StatefulWidget {
  final String quizId;

  const EditOrStartQuiz({super.key, required this.quizId});

  @override
  State<EditOrStartQuiz> createState() => _EditOrStartQuizState();
}

class _EditOrStartQuizState extends State<EditOrStartQuiz> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            children: [SelectableText("Your quiz Id :${widget.quizId}",style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),),
            const SizedBox(
              height: 20,
            ),
             SubmitButton(text: "Test Your Quiz", onpressed: (){
               Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>DisplayQuestion(quizId: widget.quizId)));
             },)],
          ),
              ))
        ],
      ),
    );
  }
}
