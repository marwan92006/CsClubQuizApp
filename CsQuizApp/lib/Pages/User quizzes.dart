
import 'package:csquizapp/Pages/Attendance%20or%20quizId%20.dart';
import 'package:csquizapp/Pages/Attendance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UserQuiz extends StatefulWidget {
  final String? quizId;

  const UserQuiz({super.key, this.quizId});

  @override
  State<UserQuiz> createState() => _UserQuizState();
}

class _UserQuizState extends State<UserQuiz> {
  final User? user = FirebaseAuth.instance.currentUser!;
  late final ref;

  @override
  void initState() {
    ref = FirebaseDatabase.instance.ref("Private/User's quizzes/${user?.uid}");
    super.initState();
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
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Expanded(
                    child: FirebaseAnimatedList(
                        query: ref,
                        itemBuilder: (context, snapshot, animation, index) {
                          return Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                      "Title: ${snapshot.child("QuizTitle").value.toString()}"),
                                  subtitle: Text(
                                      "Description: ${snapshot.child("QuizDescription").value.toString()}"),
                                  trailing: IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                "This Quiz is about to be deleted Permanently !",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    FirebaseDatabase.instance
                                                        .ref(
                                                            "Public/Public quizzes/${snapshot.child("QuizId").value.toString()}")
                                                        .remove();
                                                    FirebaseDatabase.instance
                                                        .ref(
                                                            "Private/User's quizzes/${user?.uid}/${snapshot.child("QuizId").value.toString()}")
                                                        .remove();
                                                    FirebaseStorage.instance
                                                        .ref(snapshot
                                                            .child("QuizId")
                                                            .value
                                                            .toString())
                                                        .listAll()
                                                        .then((value) => {
                                                              value.items
                                                                  .forEach(
                                                                      (element) {
                                                                FirebaseStorage
                                                                    .instance
                                                                    .ref(element
                                                                        .fullPath)
                                                                    .delete();
                                                              })
                                                            });
                                                        Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        color: Colors.red[900],
                                                        fontSize: 18),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.green[900],
                                                        fontSize: 18),
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                  leading: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AttendanceOrQuizId(
                                                    quizId: snapshot
                                                        .child("QuizId")
                                                        .value
                                                        .toString(),
                                                  )));
                                    },
                                    icon: Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.identity()
                                        ..scale(-1.0, 1.0, 1.0),
                                      child: const Icon(
                                        Icons.more,
                                      ),
                                    ),
                                  ),
                                ),
                              ));
                        }))
              ],
            )),
          )
        ]));
  }
}
