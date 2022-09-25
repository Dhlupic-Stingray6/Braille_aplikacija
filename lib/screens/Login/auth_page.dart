import 'package:braille_app/screens/Login/login.dart';
import 'package:braille_app/screens/Login/signup.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) =>
      isLogin ? Signup(onClickedSignup: toggle) : Login(onClickedLogin: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
