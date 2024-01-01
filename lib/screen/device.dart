import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tubes_iot/style/color.dart';
import 'package:tubes_iot/style/container_style.dart';
import 'package:tubes_iot/style/text.dart';

class Device extends StatefulWidget {
  const Device({super.key});

  @override
  State<Device> createState() => _DeviceState();
}

class _DeviceState extends State<Device> {
  final ref = FirebaseDatabase.instance.ref();
  final uid = FirebaseAuth.instance.currentUser?.uid;
  late bool isOpen;

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: StreamBuilder(
          stream: ref.onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.connectionState == ConnectionState) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              final userLoker =
                  snapshot.data!.snapshot.child("loker/1234/userLoker").value;
              final nameLoker =
                  snapshot.data!.snapshot.child("loker/1234/nameLoker").value;
              final dataIsOpen =
                  snapshot.data!.snapshot.child("loker/1234/isOpen").value;

              print("data is : $dataIsOpen");
              isOpen = dataIsOpen.toString() == 'true';
              print("is open : $isOpen");
              if (userLoker.toString() == uid.toString()) {
                return Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(10),
                  height: 70,
                  decoration: cardContainer,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        child: Image.asset(
                          "assets/images/loker1.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Smart Locker",
                            style: text_14_500,
                          ),
                          Text(
                            nameLoker.toString(),
                            style: text_12_500,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 40,
                        height: 20,
                        child: Switch(
                          value: isOpen,
                          activeColor: orange,
                          onChanged: (value) async {
                            await ref
                                .child("loker/1234")
                                .update({'isOpen': !isOpen});
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await ref
                                .child("loker/1234")
                                .update({
                                  'isOpen': false,
                                  'userLoker': 0,
                                });
                        },
                        child: FaIcon(
                          FontAwesomeIcons.rightFromBracket,
                          size: 18,
                          color: brown,
                        ),
                      )
                    ],
                  ),
                );
              }
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}