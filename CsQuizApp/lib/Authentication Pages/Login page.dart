import 'package:csquizapp/Authentication%20Pages/Forgot%20password.dart';
import 'package:csquizapp/UI%20components/Password%20text%20field.dart';
import 'package:csquizapp/UI%20components/Squaretile.dart';
import 'package:csquizapp/UI%20components/Text%20field.dart';
import 'package:csquizapp/UI%20components/fancydividers.dart';
import 'package:csquizapp/UI%20components/submit%20button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  final Function()? onTap;
  const Login({super.key, required this.onTap});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool transfer = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Cs Club Quiz App" ,),
            leading: Image.asset("lib/images/official-logo.png"),
            backgroundColor: Color(0xff252C4A)
        ),
        backgroundColor: const Color(0xff252C4A),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              const Icon(
                Icons.lock,
                size: 100,
                color: Colors.white70,
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Welcome back you were missed",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Textfield(
                controller: usernameController,
                hintText: 'Email',
                obscureText: false,
              ),
              const SizedBox(
                height: 10,
              ),
              PasswordTextfield(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(
                height: 10,
              ),
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const ForgotPassword()));
                      },
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SubmitButton(
                text: "Sign In",
                onpressed: signIn,
              ),
              const SizedBox(
                height: 20,
              ),
              const Fancydividers(),
              const SizedBox(
                height: 20,
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Squaretile(
                    onTap: signInWithGoogle,
                    imagespath: 'lib/images/google.png',
                    height: 50,
                  ),

                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Not a member?",
                  style: TextStyle(
                    color: Colors.white,
                  ),),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                      onTap: widget.onTap,
                      child:  Text(
                        "Register now!",
                        style: TextStyle(
                          color: Colors.blue[600],
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              )
            ],
          ),
        ))));
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

  void signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usernameController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      showSnackbarMessage(context, '$e');
    }
    Navigator.pop(context);
  }
  signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);
    return FirebaseAuth.instance.signInWithCredential(credential);
  }
}
