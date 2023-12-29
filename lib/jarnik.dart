import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tubes_iot/style/text.dart';

class Jarnik extends StatefulWidget {
  const Jarnik({super.key});

  @override
  State<Jarnik> createState() => _JarnikState();
}

class _JarnikState extends State<Jarnik> {
  final ref = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 80, right: 30, left: 30, bottom: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                    stream: ref.onValue,
                    builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                      if (snapshot.connectionState == ConnectionState) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        final data = snapshot.data!;
                        String textMentah = data.snapshot
                            .child("lockers_status/1/status")
                            .value
                            .toString();

                        return Text(
                          data.snapshot
                              .child("lockers_status/1/status")
                              .value
                              .toString(),
                          style: text_22_700,
                        );
                      }
                      return const Text("error");
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
