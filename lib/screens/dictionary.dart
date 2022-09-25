import 'package:flutter/material.dart';

import 'package:braille_app/letters.dart' as letters;

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});
  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.amber[300],
        body: Column(
          children: [
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
                        width: 300,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              bottomLeft: Radius.circular(50),
                            )),
                      )),
                  const Positioned(
                      top: 90,
                      right: 30,
                      child: Text(
                        'Rječnik slova',
                        style:
                            TextStyle(fontSize: 30, color: Colors.deepPurple),
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
            Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200.0,
                            mainAxisSpacing: 20.0,
                            crossAxisSpacing: 20.0,
                            childAspectRatio: 1.0),
                    delegate: SliverChildBuilderDelegate(
                      childCount: letters.map.length,
                      (BuildContext context, int index) {
                        return Container(
                            padding: const EdgeInsets.only(left: 50),
                            alignment: Alignment.center,
                            color: Colors.purpleAccent,
                            child: Row(
                              children: [
                                Text(letters.letter[index]),
                                Image.asset(
                                    'assets/images/Slova/${letters.letter[index]}.png')
                              ],
                            ));
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
}
