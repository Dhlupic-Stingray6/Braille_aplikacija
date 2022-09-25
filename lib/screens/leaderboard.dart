import 'dart:collection';

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:braille_app/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  final user = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseDatabase(
            databaseURL: "https://braille-app-9b4fd.firebaseio.com/")
        .ref()
        .child("Users");

    return Scaffold(
        appBar: AppBar(
          title: Text("Leaderboard"),
        ),
        backgroundColor: Colors.lime,
        resizeToAvoidBottomInset: false,
        body: Column(children: [
          Card(
            color: Colors.amber[300],
            margin: EdgeInsets.only(bottom: 15),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(children: [
                Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: Text(
                          ("Username"),
                          style: TextStyle(fontSize: 34),
                        )),
                    Expanded(
                      child: Text(
                        'Bodovi',
                        style: TextStyle(fontSize: 24),
                      ),
                      flex: 2,
                    )
                  ],
                )
              ]),
            ),
          ),
          SingleChildScrollView(
            child: (FirebaseAnimatedList(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              query: ref.orderByChild('orderPoints'),
              itemBuilder: ((context, snapshot, animation, index) {
                final data = snapshot.value as Map;

                return Card(
                    color: Colors.green,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Column(children: [
                        Row(
                          children: [
                            Expanded(
                                flex: 5,
                                child: Text(
                                  data["username"],
                                  style: TextStyle(fontSize: 24),
                                )),
                            Expanded(
                                flex: 1, child: Text(data['points'].toString()))
                          ],
                        )
                      ]),
                    ));
              }),
            )),
          ),
        ]));
  }
}
