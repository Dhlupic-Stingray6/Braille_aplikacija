// ignore_for_file: deprecated_member_use

import 'package:braille_app/screens/PlayScreen/gameLetters.dart';
import 'package:braille_app/screens/PlayScreen/gameNumbers.dart';
import 'package:braille_app/screens/PlayScreen/gameReverse.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class StartLearning extends StatefulWidget {
  const StartLearning({super.key});

  @override
  State<StartLearning> createState() => _StartLearning();
}

class _StartLearning extends State<StartLearning> {
  late var points = "";
  late int? intPoints = 0;
  int myLevel = 1;
  bool lvledUp = false;
  bool lvledBeyond = false;
  final user = FirebaseAuth.instance;

  getPoints() {
    final ref = FirebaseDatabase(
            databaseURL: "https://braille-app-9b4fd.firebaseio.com/")
        .ref("Users/${user.currentUser!.uid}/points");

    Stream<DatabaseEvent> points_stream = ref.onValue;

    points_stream.listen((DatabaseEvent event) {
      setState(() {
        points = event.snapshot.value.toString();
        intPoints = int.tryParse(points);
        if (intPoints! > 1350) {
          lvledUp = true;
        }

        if (intPoints! > 3500) {
          lvledBeyond = true;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();

    getPoints();
  }

  @override
  Widget build(BuildContext context) {
    //print("prvi");
    //print(intPoints);
    return Scaffold(
      backgroundColor: Colors.amber[300],
      body: Column(children: [
        Container(
          height: 175,
          margin: const EdgeInsets.only(bottom: 15),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
            ),
            color: Colors.deepPurple,
          ),
          child: Stack(
            children: [
              Positioned(
                  top: 80,
                  right: 0,
                  child: Container(
                    height: 60,
                    width: 150,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                        )),
                  )),
              Positioned(
                top: 100,
                left: 40,
                child: Text(
                  "Bodovi: $points",
                  style: const TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontSize: 24),
                ),
              ),
              const Positioned(
                  top: 90,
                  right: 50,
                  child: Text(
                    'Igraj',
                    style: TextStyle(fontSize: 30, color: Colors.deepPurple),
                  )),
              Positioned(
                  top: 30,
                  left: 0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0.0, shadowColor: Colors.transparent),
                    child: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )),
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GameLetter()));
              },
              child: const Text('Slova')),
        ),
        Container(
          margin: const EdgeInsets.only(top: 50, bottom: 20),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 75),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)))),
              onPressed: lvledUp
                  ? () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GameNumbers()));
                    }
                  : null,
              child: lvledUp
                  ? const Text('Brojevi')
                  : const Text(
                      'Skupi 1350 bodova za ovu razinu',
                      style: TextStyle(fontSize: 7, color: Colors.red),
                    )),
        ),
        Container(
          margin: const EdgeInsets.only(top: 50, bottom: 20),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 75),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)))),
              onPressed: lvledBeyond
                  ? () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GameReverse()));
                    }
                  : null,
              child: lvledBeyond
                  ? const Text('Natraške')
                  : const Text(
                      'Skupi 3500 bodova za ovu razinu',
                      style: TextStyle(fontSize: 7, color: Colors.red),
                    )),
        ),
      ]),
    );
  }
}
