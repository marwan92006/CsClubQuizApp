import 'dart:io';

import 'package:csquizapp/Pages/HomePage.dart';
import 'package:csquizapp/UI%20components/QuestionsTextField.dart';
import 'package:csquizapp/UI%20components/Text%20field.dart';
import 'package:csquizapp/UI%20components/submit%20button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class AddQuestions extends StatefulWidget {
  final String quizId;
  final String quizTitle;
  final String quizDescription;

  const AddQuestions(
      {super.key,
      required this.quizId,
      required this.quizTitle,
      required this.quizDescription});

  @override
  State<AddQuestions> createState() => _AddQuestionsState();
}

class _AddQuestionsState extends State<AddQuestions> {
  int numberOfQuestions = 1;
  final questionController = TextEditingController();

  int correctAnswerIndex = 1;

  String imageUrl = "";

  final answerOneController = TextEditingController();

  final answerTwoController = TextEditingController();

  final answerThreeController = TextEditingController();

  final answerFourController = TextEditingController();

  final User? user = FirebaseAuth.instance.currentUser!;

  bool isImageSent = false;

  List<int> durations = [5, 10, 20, 30, 60, 120, 180, 240, 300];
  int selectedDuration = 20;

  void showSnackbarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void finish() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomePage(
              quizId: widget.quizId,
            )));
  }

  sendQuestionData() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    if (questionController.text.isEmpty) {
      showSnackbarMessage(context, "A question is required");
      Navigator.pop(context);
    } else if (answerOneController.text.isEmpty ||
        answerTwoController.text.isEmpty ||
        answerThreeController.text.isEmpty ||
        answerFourController.text.isEmpty) {
      showSnackbarMessage(context, "Four options and one answer are required");
      Navigator.pop(context);
    } else {
      try {
        DatabaseReference refPublic = FirebaseDatabase.instance
            .ref("Public/Public quizzes/${widget.quizId}");
        DatabaseReference refPrivate = FirebaseDatabase.instance
            .ref("Private/User's quizzes/${user?.uid}/${widget.quizId}");
        await refPublic.update({
          "Question $numberOfQuestions": questionController.text.toString(),
          "Number of questions": numberOfQuestions,
          "Choices $numberOfQuestions": {
            "Option 1": answerOneController.text.toString(),
            "Option 2": answerTwoController.text.toString(),
            "Option 3": answerThreeController.text.toString(),
            "Option 4": answerFourController.text.toString(),
            "CorrectAnswerIndex": correctAnswerIndex,
            "ImageUrl": imageUrl,
            "Duration": selectedDuration,
          }
        });
        await refPrivate.update({
          "Question $numberOfQuestions": questionController.text.toString(),
          "Number of questions": numberOfQuestions,
          "Choices $numberOfQuestions": {
            "Option 1": answerOneController.text.toString(),
            "Option 2": answerTwoController.text.toString(),
            "Option 3": answerThreeController.text.toString(),
            "Option 4": answerFourController.text.toString(),
            "CorrectAnswerIndex": correctAnswerIndex,
            "ImageUrl": imageUrl,
            "Duration": selectedDuration,
          }
        });
      } on FirebaseException catch (e) {
        showSnackbarMessage(context, '$e');
      }
      Navigator.pop(context);
      setState(() {
        numberOfQuestions++;
        isImageSent = false;
      });
      questionController.clear();
      answerOneController.clear();
      answerTwoController.clear();
      answerThreeController.clear();
      answerFourController.clear();
      imageUrl = "";
    }
  }

  sendImage(ImageSource imageSource) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: imageSource);
    Navigator.of(context).pop();
    Reference referenceRoot = FirebaseStorage.instance.ref(widget.quizId);
    Reference referenceImageToUpload =
        referenceRoot.child("Question $numberOfQuestions");
    await referenceImageToUpload.putFile(File(file!.path));
    imageUrl = await referenceImageToUpload.getDownloadURL();
    setState(() {
      isImageSent = true;
    });
    showSnackbarMessage(context, "Your image has been Uploaded");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          backgroundColor: const Color(0xff252C4A),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text(
                  "Quiz title: ${widget.quizTitle}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                 Text(
                  "Quiz description: ${widget.quizDescription}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                SelectableText(
                  "Quiz id: ${widget.quizId}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text("Correct option index",
                    style: TextStyle(color: Colors.white)),
                Theme(
                  data: Theme.of(context).copyWith(
                      unselectedWidgetColor: Colors.red,
                      disabledColor: Colors.blue),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "1",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Radio(
                          activeColor: Colors.green,
                          value: 1,
                          groupValue: correctAnswerIndex,
                          onChanged: (value) {
                            setState(() {
                              correctAnswerIndex = value!;
                            });
                          }),
                      Radio(
                          activeColor: Colors.green,
                          value: 2,
                          groupValue: correctAnswerIndex,
                          onChanged: (value) {
                            setState(() {
                              correctAnswerIndex = value!;
                            });
                          }),
                      const Text("2",
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ],
                  ),
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                      unselectedWidgetColor: Colors.red,
                      disabledColor: Colors.blue),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("3",
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      Radio(
                          activeColor: Colors.green,
                          value: 3,
                          groupValue: correctAnswerIndex,
                          onChanged: (value) {
                            setState(() {
                              correctAnswerIndex = value!;
                            });
                          }),
                      Radio(
                          activeColor: Colors.green,
                          value: 4,
                          groupValue: correctAnswerIndex,
                          onChanged: (value) {
                            setState(() {
                              correctAnswerIndex = value!;
                            });
                          }),
                      const Text("4",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          )),
                    ],
                  ),
                ),
                DropdownButtonFormField(
                  icon: const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: Colors.white70,
                  ),
                  dropdownColor: Colors.black54,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    labelText: "Durations",
                    labelStyle: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.timer_outlined,
                      color: Colors.white70,
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                  ),
                  hint: const Text("Duration",
                      style: TextStyle(color: Colors.white)),
                  items: durations.map((duration) {
                    return DropdownMenuItem(
                      value: duration,
                      child: Text("$duration seconds",
                          style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedDuration = newValue!;
                    });
                  },
                  value: selectedDuration,
                )
              ],
            ),
          ),
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
            child: SafeArea(
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Textfield(
                    controller: questionController,
                    obscureText: false,
                    hintText: "Question $numberOfQuestions",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(25.00, 0.0, 25.00, 0),
                      child: isImageSent
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.fill,
                            )
                          : Container(
                              width: 420,
                              height: 200,
                              decoration: BoxDecoration(
                                  color: const Color(0xffEEEEEE),
                                  border: Border.all(
                                    color: Colors.indigo,
                                    width: 3,
                                  )),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      iconSize: 70,
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                actions: [
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          sendImage(ImageSource
                                                              .camera);
                                                        },
                                                        icon: const Icon(Icons
                                                            .camera_alt_outlined),
                                                        iconSize: 73,
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          sendImage(ImageSource
                                                              .gallery);
                                                        },
                                                        icon: const Icon(Icons
                                                            .image_outlined),
                                                        iconSize: 71,
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        icon: const Icon(Icons
                                                            .cancel_outlined),
                                                        iconSize: 71,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      icon: const Icon(
                                        Icons.upload_file_outlined,
                                      )),
                                  const Text(
                                    "Upload image (optional)",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                  isImageSent
                      ? IconButton(
                          onPressed: () {
                            FirebaseStorage.instance
                                .ref(widget.quizId)
                                .child("Question $numberOfQuestions")
                                .delete();
                            setState(() {
                              isImageSent = false;
                            });
                          },
                          icon: const Icon(Icons.delete),
                          color: Colors.red[900],
                          iconSize: 50,
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          QuestionsTextField(
                            hintText: "Option 1",
                            obscureText: false,
                            controller: answerOneController,
                            color: Colors.green[800],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          QuestionsTextField(
                            hintText: "Option 2",
                            obscureText: false,
                            controller: answerTwoController,
                            color: Colors.blue[800],
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Column(
                        children: [
                          QuestionsTextField(
                            hintText: "Option 3",
                            obscureText: false,
                            controller: answerThreeController,
                            color: Colors.red[800],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          QuestionsTextField(
                            hintText: "Option 4",
                            obscureText: false,
                            controller: answerFourController,
                            color: Colors.yellow[800],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SubmitButton(
                    text: "Submit",
                    onpressed: sendQuestionData,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SubmitButton(
                    onpressed: finish,
                    text: "Finish",
                  ),
                ],
              )),
            ),
          ),
        ]));
  }
}
