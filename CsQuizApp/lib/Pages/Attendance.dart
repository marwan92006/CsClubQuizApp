import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Attendance extends StatefulWidget {
  final String quizId;

  const Attendance({super.key, required this.quizId});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final User? user = FirebaseAuth.instance.currentUser!;
  late final ref;

  @override
  void initState() {
    ref = FirebaseDatabase.instance.ref(
        "Private/User's quizzes/${user?.uid}/${widget.quizId}/Attendance");
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
        body: Stack(
            children: [
              SvgPicture.asset(
                "lib/images/bg.svg",
                fit: BoxFit.fill,
              ),
              SafeArea(child: Expanded(
                  child: FirebaseAnimatedList(
                      query: ref,
                      itemBuilder: (context, snapshot, animation, index) {
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Card(
                            color: Colors.white70,
                            child: ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Name: ${snapshot
                                              .child("Name")
                                              .value
                                              .toString()}", style: TextStyle(
                                            color: Colors.blue[900]
                                        ),),
                                        Text(
                                            "   Score: ${snapshot
                                                .child("Score")
                                                .value
                                                .toString()}", style: TextStyle(
                                            color: Colors.green[800])),
                                      ],
                                    ),
                                  ],
                                ),

                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        SelectableText(
                                          "Uid: ${snapshot
                                              .child("Uid")
                                              .value
                                              .toString()}", style: TextStyle(
                                            color: Colors.red[900]
                                        ),),
                                        Text(
                                            "Date: ${snapshot
                                                .child("Date")
                                                .value
                                                .toString()}", style: TextStyle(
                                            color: Colors.yellow[400])),
                                      ],
                                    ),
                                  ],
                                ) ,
                            ),
                          ),
                        );
                      })),
              )
            ]));
  }
}
