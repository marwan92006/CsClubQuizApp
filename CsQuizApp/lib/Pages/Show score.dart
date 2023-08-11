import 'package:csquizapp/UI%20components/submit%20button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class ShowScore extends StatefulWidget {
  final int  score;
  final int  totalQuestion;
  final String correctQuestion;
  const ShowScore({super.key, required this.score, required this.totalQuestion, required this.correctQuestion});

  @override
  State<ShowScore> createState() => _ShowScoreState();
}
bool showCorrectQuestions= false;
class _ShowScoreState extends State<ShowScore> {
  void viewDetails(){
    setState(() {
      showCorrectQuestions =true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Stack(children:[
        SvgPicture.asset("lib/images/bg.svg", fit: BoxFit.fill,),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Text(
                "Your scored ${widget.score} out of ${widget.totalQuestion}",style: const TextStyle(
                color: Colors.white,
                fontSize: 30
              ),
              ),
              const SizedBox(
                height: 20,
              ),
              SubmitButton(text: "View details", onpressed: viewDetails,),
              const SizedBox(
                height: 60,
              ),
              showCorrectQuestions?
              Text(widget.correctQuestion,style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),):const SizedBox(),
            ],
          ),
        ),
    ]));
  }
}
