import 'package:braille_app/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fluttertoast/fluttertoast.dart';

class Signup extends StatefulWidget {
  final Function() onClickedSignup;

  const Signup({
    Key? key,
    required this.onClickedSignup,
  }) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpassController = TextEditingController();
  final referencedb =
      FirebaseDatabase(databaseURL: "https://braille-app-9b4fd.firebaseio.com/")
          .ref();

  Future signUp() async {
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ),
        barrierDismissible: false);
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          )
          .then((value) =>
              referencedb.child('Users').child('${value.user?.uid}').set({
                'username': usernameController.text.trim(),
                'email': emailController.text.trim(),
                'points': 0,
                'orderPoints': 0,
              }));
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
          msg: e.message.toString(), backgroundColor: Colors.red);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst == true);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[300],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50)),
                color: Colors.deepPurple,
              ),
              child: Stack(
                children: [
                  Positioned(
                      top: 60,
                      left: 60,
                      child: Container(
                        height: 60,
                        width: 300,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                      )),
                  const Positioned(
                      top: 70,
                      left: 145,
                      child: Text(
                        'Sign up',
                        style:
                            TextStyle(fontSize: 30, color: Colors.deepPurple),
                      ))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: usernameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.5),
                            borderSide: BorderSide(color: Colors.deepPurple)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple),
                            borderRadius: BorderRadius.circular(5.5)),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.deepPurple,
                        ),
                        labelText: 'Enter username ',
                        filled: true,
                        fillColor: Colors.greenAccent[100],
                        hintStyle: TextStyle(color: Colors.deepPurple)),
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  TextFormField(
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.5),
                            borderSide: BorderSide(color: Colors.deepPurple)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple),
                            borderRadius: BorderRadius.circular(5.5)),
                        prefixIcon: Icon(
                          Icons.mail,
                          color: Colors.deepPurple,
                        ),
                        labelText: 'Enter your email',
                        filled: true,
                        fillColor: Colors.greenAccent[100],
                        hintStyle: TextStyle(color: Colors.deepPurple)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.5),
                            borderSide: BorderSide(color: Colors.deepPurple)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple),
                            borderRadius: BorderRadius.circular(5.5)),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.deepPurple,
                        ),
                        labelText: 'Enter your password',
                        filled: true,
                        fillColor: Colors.greenAccent[100],
                        hintStyle: TextStyle(color: Colors.deepPurple)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: confirmpassController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.5),
                            borderSide: BorderSide(color: Colors.deepPurple)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple),
                            borderRadius: BorderRadius.circular(5.5)),
                        prefixIcon: Icon(
                          Icons.lock_clock_outlined,
                          color: Colors.deepPurple,
                        ),
                        labelText: 'Confirm  password',
                        filled: true,
                        fillColor: Colors.greenAccent[100],
                        hintStyle: TextStyle(color: Colors.deepPurple)),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(left: 100, right: 100),
                      maximumSize: const Size.fromHeight(50),
                    ),
                    icon: const Icon(
                      Icons.lock_open,
                      size: 24,
                    ),
                    label: const Text(
                      'Sign up',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      if (passwordController.text !=
                          confirmpassController.text) {
                        Fluttertoast.showToast(
                            msg: "Passwords do not match!",
                            backgroundColor: Colors.red);
                      } else {
                        signUp();
                      }
                    },
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          text: 'Already have an account?  ',
                          children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onClickedSignup,
                          text: 'Log in',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).colorScheme.secondary),
                        )
                      ]))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
