import 'dart:convert';
import 'package:braille_app/screens/Login/signup.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:braille_app/models/users.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Updateuser {
  final String username;

  const Updateuser({required this.username});

  factory Updateuser.fromJson(Map<String, dynamic> json) {
    return Updateuser(username: json['username']);
  }
}

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final updateUserController = TextEditingController();
  final user = FirebaseAuth.instance;
  var username = '';
  var email = '';
  late var points;
  late Future<Updateuser> updateuser;
  late Future<CurrentUser> getcurrentuser;
  late final url = Uri.parse(
    "https://braille-app-9b4fd.firebaseio.com/Users/${user.currentUser!.uid}.json",
  );

  Future<void> _resetXp() async {
    final ref = FirebaseDatabase(
            databaseURL: "https://braille-app-9b4fd.firebaseio.com/")
        .ref("Users/${user.currentUser!.uid}");

    await ref.update({"points": 0, "orderPoints": 0});
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<CurrentUser> getUser() async {
    final response = await http.get(url);

    print(response.statusCode);
    if (response.statusCode == 200) {
      return CurrentUser.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<Updateuser> updateUser(String username) async {
    final response = await http.patch(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
        }));

    if (response.statusCode == 200) {
      return (Updateuser.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Failed to update user');
    }
  }

  @override
  void initState() {
    super.initState();

    getcurrentuser = getUser();
  }

  @override
  void dispose() {
    updateUserController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lime,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FutureBuilder<CurrentUser>(
                  future: getcurrentuser,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                          height: 200,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(50),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(25)),
                            color: Colors.deepPurple,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 50, right: 50, bottom: 50, left: 10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email: ${snapshot.data!.email}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Nadimak: ${snapshot.data!.username}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Bodovi: ${snapshot.data!.points}',
                                    style: const TextStyle(
                                        color: Colors.lime, fontSize: 20),
                                  ),
                                ]),
                          ));
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ),
                const SizedBox(
                  width: 50,
                ),
                ElevatedButton(
                  child: const Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              backgroundColor: Colors.greenAccent,
                              title: const Text('Change username'),
                              content: TextField(
                                controller: updateUserController,
                                decoration: const InputDecoration(
                                    hintText: 'Promjeni nadimak'),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      if (mounted) {
                                        if (updateUserController.text == "") {
                                          Navigator.pop(context);
                                        } else {
                                          setState(() {
                                            updateuser = updateUser(
                                                updateUserController.text);

                                            getcurrentuser = getUser();
                                            Navigator.pop(context);
                                          });
                                        }
                                      }
                                    },
                                    child: const Text('Promjeni'))
                              ],
                            ));
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  child: const Text('Resetiraj bodove'),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              backgroundColor: Colors.greenAccent,
                              title: const Text('Oprez!'),
                              content: const Text(
                                  'Ovom radnjom će te postaviti vaše bodove na nulu! Jeste li sigurni?'),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration: const BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Text(
                                        'Prekini',
                                        style: TextStyle(
                                            color: Colors.red[500],
                                            fontSize: 20),
                                      ),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      if (mounted) {
                                        setState(() {
                                          _resetXp();
                                          getUser();
                                          Navigator.pop(context);
                                        });
                                      }
                                    },
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
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ))
                              ],
                            ));
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Container(
          margin: const EdgeInsets.only(bottom: 45),
          child: ElevatedButton.icon(
              onPressed: (() {
                logout();
                Navigator.pop(context);
              }),
              icon: const Icon(Icons.arrow_back_sharp),
              label: const Text("Odjava")),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 45),
          child: ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          backgroundColor: Colors.greenAccent,
                          title: const Text('Oprez!'),
                          content: const Text(
                              'Sigurno želite obrisati korisnički račun?'),
                          actions: [
                            TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: const BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Text(
                                    'Prekini',
                                    style: TextStyle(
                                        color: Colors.red[500], fontSize: 20),
                                  ),
                                )),
                            TextButton(
                                onPressed: () {
                                  user.currentUser!.delete();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Signup(
                                              onClickedSignup: () => false)));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: const BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      )),
                                  //margin: const EdgeInsets.only(right: 125),
                                  child: const Text(
                                    'Obriši moj račun',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ))
                          ],
                        ));

                /* Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Signup(
                            onClickedSignup: () => true,
                          )));*/
              },
              child: Text("Obriši moj račun")),
        ),
      ]),
    );
  }
}
