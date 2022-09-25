import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../letters.dart' as letters;

class GameReverse extends StatefulWidget {
  const GameReverse({super.key});

  @override
  State<GameReverse> createState() => _GameReverse();
}

class _GameReverse extends State<GameReverse> {
  late var points = "";
  final user = FirebaseAuth.instance;
  late TextEditingController _controller;
  var msg = <String>["Bravo!", 'Odlično!', 'Svaka čast!'];
  var poruka = '';
  var list = <int>[0, 0, 0, 0, 0, 0];
  var myLetter = '';
  var textToDisplay = '';
  var element = '';

  void rndMsg() {
    final random = Random();
    var values = msg.toList();

    poruka = values[random.nextInt(values.length)];
  }

  void rand() {
    final random = Random();
    var values = letters.map.values.toList();
    element = values[random.nextInt(values.length)];
  }

  Future<void> _incrementPoints() async {
    final ref = FirebaseDatabase(
            databaseURL: "https://braille-app-9b4fd.firebaseio.com/")
        .ref("Users/${user.currentUser!.uid}");

    TransactionResult result = await ref.runTransaction((Object? user) {
      if (user == null) {
        return Transaction.abort();
      }
      //print("ovdje");
      Map<String, dynamic> _user = Map<String, dynamic>.from(user as Map);
      _user['points'] = (_user['points'] ?? 0) + 150;
      _user['orderPoints'] = (_user['orderPoints'] ?? 0) - 150;

      return Transaction.success(_user);
    });
  }

  showPoints() {
    final ref = FirebaseDatabase(
            databaseURL: "https://braille-app-9b4fd.firebaseio.com/")
        .ref("Users/${user.currentUser!.uid}/points");

    Stream<DatabaseEvent> points_stream = ref.onValue;

    points_stream.listen((DatabaseEvent event) {
      if (mounted) {
        setState(() {
          points = event.snapshot.value.toString();
        });
      }
    });
  }

  void submit(String answer) {
    if (mounted) {
      setState(() {
        var currentNum = list.join('');
        myLetter = '';

        for (var i = 0; i < letters.map.length; i++) {
          if (currentNum == letters.id[i]) {
            myLetter = letters.letter[i];
          }
        }
        print(answer);
        print(element);
        if (answer == element) {
          rndMsg();
          Fluttertoast.showToast(
              msg: poruka,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          _controller.clear();
          rand();
          _incrementPoints();
        } else {
          Fluttertoast.showToast(
              msg: "Krivi odgovor! Probaj ponvno!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    rand();
    showPoints();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        title: Text('xp: ${points}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [],
            ),
            Container(
              margin: const EdgeInsets.only(left: 60.0, right: 60.0),
              child: Image.asset('assets/images/Slova/${element}.png'),
            ),
            Container(
              child: TextField(
                decoration: InputDecoration(
                    constraints: BoxConstraints.tightFor(width: 100)),
                controller: _controller,
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: (Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 125.0, bottom: 20),
            child: FloatingActionButton.extended(
              label: Text('Check answer!'),
              onPressed: (() {
                submit(_controller.text.toUpperCase());
              }),
            ),
          )
        ],
      )),
    );
  }
}
