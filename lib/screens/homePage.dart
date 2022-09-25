import 'package:flutter/material.dart';
import 'package:braille_app/screens/startLearn.dart';
import 'package:braille_app/screens/settings.dart';
import 'package:braille_app/screens/dictionary.dart';
import 'package:braille_app/screens/leaderboard.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.amber[300],
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              height: 175,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50),
                ),
                color: Colors.deepPurple,
              ),
              child: Stack(
                children: [
                  Positioned(
                      top: 80,
                      left: 0,
                      child: Container(
                        height: 60,
                        width: 300,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            )),
                      )),
                  const Positioned(
                      top: 90,
                      left: 30,
                      child: Text(
                        'Braille app',
                        style:
                            TextStyle(fontSize: 30, color: Colors.deepPurple),
                      ))
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 50, bottom: 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 75),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)))),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StartLearning()));
                  },
                  child: Text('Play')),
            ),
            Container(
              margin: const EdgeInsets.only(top: 50, bottom: 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 75),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)))),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DictionaryPage()));
                  },
                  child: Text('Rječnik Slova')),
            ),
            Container(
                margin: const EdgeInsets.only(top: 50, bottom: 20),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(200, 75),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50)))),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Settings()));
                    },
                    child: Text('Settings'))),
            Container(
                margin: const EdgeInsets.only(top: 50, bottom: 20),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(200, 75),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50)))),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Leaderboard()));
                    },
                    child: Text('Leaderboard'))),
          ]),
        ));
  }
}
