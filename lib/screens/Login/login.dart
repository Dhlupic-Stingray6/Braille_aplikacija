import 'package:braille_app/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  final VoidCallback onClickedLogin;

  const Login({
    Key? key,
    required this.onClickedLogin,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future logIn() async {
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ),
        barrierDismissible: false);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.amber[300],
      body: Column(
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
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                    )),
                const Positioned(
                    top: 70,
                    left: 165,
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 30, color: Colors.deepPurple),
                    ))
              ],
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
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
                  textInputAction: TextInputAction.done,
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
                    'Sign in',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: (() {
                    logIn();
                  }),
                ),
                SizedBox(
                  height: 24,
                ),
                RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        text: 'No account?  ',
                        children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedLogin,
                        text: 'Sign up',
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
    );
  }
}
