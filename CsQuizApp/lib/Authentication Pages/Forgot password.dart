import 'package:csquizapp/Authentication%20Pages/Login%20page.dart';
import 'package:csquizapp/UI%20components/Text%20field.dart';
import 'package:csquizapp/UI%20components/submit%20button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();

  void showSnackbarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(
            seconds: 2), // Optional: Set the duration to display the snackbar
      ),
    );
  }

  Future<void> sendResetEmail() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
     await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.toString());
     showSnackbarMessage(context, "Check your email");
    } on FirebaseAuthException catch (e) {
      showSnackbarMessage(context, "An error occurred: $e");
    }
    Navigator.pop(context);
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
      backgroundColor: const Color(0xff252C4A),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Textfield(
              hintText: "Email",
              obscureText: false,
              controller: emailController),
          const SizedBox(
            height: 20,
          ),
          SubmitButton(
            text: "Send reset email",
            onpressed: sendResetEmail,
          )
        ],
      ),
    );
  }
}
