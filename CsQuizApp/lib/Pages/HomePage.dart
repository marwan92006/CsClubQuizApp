import 'package:csquizapp/Pages/CreateQuiz.dart';
import 'package:csquizapp/UI%20components/Drawable%20Navigation%20bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'StartQuiz.dart';

class HomePage extends StatefulWidget {
  final Function()? createQuiz;
  final String quizId;

  const HomePage({super.key, this.createQuiz, required this.quizId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const SideNavigationBar(
        ),
        appBar: AppBar(
            title: const Text(
              "Cs Club Quiz App",
            ),
            backgroundColor: const Color(0xff252C4A)),
        body: Stack(children: [
          SvgPicture.asset(
            "lib/images/bg.svg",
            fit: BoxFit.fill,
            height: 1080,
            width: 1920,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.quiz_outlined,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const CreateQuiz()));
                      },
                      iconSize: 60,
                      color: Colors.white,
                    ),
                    const Text(
                      "Create Quiz",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 50,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.start_rounded),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const StartQuiz()));
                      },
                      iconSize: 60,
                      color: Colors.white,
                    ),
                    const Text(
                      "Start Quiz",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ]));
  }
}
