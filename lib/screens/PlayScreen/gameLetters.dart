import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../letters.dart' as letters;

class GameLetter extends StatefulWidget {
  const GameLetter({super.key});

  @override
  State<GameLetter> createState() => _GameLetter();
}

class _GameLetter extends State<GameLetter> {
  late var points = "";
  final user = FirebaseAuth.instance;
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

  dynamic _incrementCounter(int n) {
    if (list[n] == 0) {
      list[n] = 1;
    } else {
      list[n] = 0;
    }

    setState(() {
      textToDisplay = list.join('');
    });
  }

  void submit() {
    if (mounted) {
      setState(() {
        var currentNum = list.join('');
        myLetter = '';

        for (var i = 0; i < letters.map.length; i++) {
          if (currentNum == letters.id[i]) {
            myLetter = letters.letter[i];

            textToDisplay = list.join('');
          }
        }

        if (element == myLetter) {
          rndMsg();
          _incrementPoints();
          Fluttertoast.showToast(
              msg: poruka,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);

          rand();

          //_incrementXP();
        } else {
          Fluttertoast.showToast(
              msg: "Krivi odgovor! Probaj ponvno!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        list = [0, 0, 0, 0, 0, 0];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    rand();

    showPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        title: Text(points),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton.large(
                  heroTag: 'hero1',
                  backgroundColor:
                      list[0] == 0 ? Colors.deepPurple : Colors.amber[900],
                  onPressed: (() => {
                        _incrementCounter(0),
                      }),
                  child: const Text(''),
                ),
                FloatingActionButton.large(
                  heroTag: UniqueKey(),
                  backgroundColor:
                      list[1] == 0 ? Colors.deepPurple : Colors.amber[900],
                  onPressed: (() => _incrementCounter(1)),
                  child: Text(''),
                ),
                FloatingActionButton.large(
                  heroTag: UniqueKey(),
                  backgroundColor:
                      list[2] == 0 ? Colors.deepPurple : Colors.amber[900],
                  onPressed: (() => _incrementCounter(2)),
                  child: const Text(''),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 55.0, right: 55.0),
              child: Text(
                element,
                style: const TextStyle(fontSize: 65),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton.large(
                  heroTag: UniqueKey(),
                  backgroundColor:
                      list[3] == 0 ? Colors.deepPurple : Colors.amber[900],
                  onPressed: (() => _incrementCounter(3)),
                  child: const Text(''),
                ),
                FloatingActionButton.large(
                  backgroundColor:
                      list[4] == 0 ? Colors.deepPurple : Colors.amber[900],
                  heroTag: UniqueKey(),
                  onPressed: (() => _incrementCounter(4)),
                  child: const Text(''),
                ),
                FloatingActionButton.large(
                  backgroundColor:
                      list[5] == 0 ? Colors.deepPurple : Colors.amber[900],
                  heroTag: UniqueKey(),
                  onPressed: (() => _incrementCounter(5)),
                  child: const Text(''),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: (Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 25, bottom: 20),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            backgroundColor: Colors.greenAccent,
                            title: const Text('Hint'),
                            content: (Image.asset(
                                'assets/images/Slova/${element}.png')),
                            actions: [
                              TextButton(
                                  onPressed: Navigator.of(ctx).pop,
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: const BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        )),
                                    //margin: const EdgeInsets.only(right: 125),
                                    child: const Text(
                                      'Ok',
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ))
                            ],
                          ));
                },
                child: const Text('?')),
          ),
          Container(
            margin: EdgeInsets.only(left: 100.0, bottom: 20),
            child: FloatingActionButton.extended(
              label: Text('Check answer!'),
              onPressed: (() {
                submit();
              }),
            ),
          )
        ],
      )),
    );
  }
}
