import 'package:csquizapp/Pages/User%20quizzes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SideNavigationBar extends StatefulWidget {

  const SideNavigationBar({super.key,});

  @override
  State<SideNavigationBar> createState() => _SideNavigationBarState();
}

class _SideNavigationBarState extends State<SideNavigationBar> {
  final user = FirebaseAuth.instance.currentUser!.email!;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xff252C4A),
      child: ListView(
          padding: EdgeInsets.zero,
          children: [
          UserAccountsDrawerHeader(

          accountEmail: Text(user),
      accountName: const Text("Logged in as: "),
    ),
    const SizedBox(
    height: 20,
    ),
    ListTile(
    onTap: (){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const UserQuiz()));
    },
    leading: const Icon(Icons.quiz_outlined,
    size:40 ,
    color: Colors.white,),
    title: const Text("Your Quizzes ", style: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.white70
    ),),
    ),
    const SizedBox(
    height: 20,
    ),
    ListTile(
    onTap: (){
    FirebaseAuth.instance.signOut();
    },
    leading: const Icon(Icons.logout,
    size:40 ,
    color: Colors.white),
    title: const Text("Sign out ", style: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.white70
    ),),
    ),
    ],
    ),
    );
  }
}
