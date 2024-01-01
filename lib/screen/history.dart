import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:tubes_iot/style/color.dart';
import 'package:tubes_iot/style/container_style.dart';
import 'package:tubes_iot/style/text.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final ref = FirebaseDatabase.instance.ref();
  final uid = FirebaseAuth.instance.currentUser?.uid;
  List<List<String>> dataList = [], dataList2 = [];

  String getDateFromUnixTime(String timestamp) {
    int time = int.tryParse(timestamp) ?? 0;
    DateTime dateTimeFromSeconds =
        DateTime.fromMillisecondsSinceEpoch(time * 1000);

    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTimeFromSeconds);
    return formattedDate;
  }

  String getTimeFromUnixTime(String timestamp) {
    int time = int.tryParse(timestamp) ?? 0;
    DateTime dateTimeFromSeconds =
        DateTime.fromMillisecondsSinceEpoch(time * 1000);

    String formattedDate = DateFormat('HH:mm:ss').format(dateTimeFromSeconds);
    return formattedDate;
  }

  List<List<String>> cleanString(String dataString) {
    String cleanString =
        dataString.replaceAll('{', '').replaceAll('}', '').replaceAll(':', '');

    List<String> keyValuePairs = cleanString.split(', ');

    return keyValuePairs.map((pair) {
      List<String> entry = pair.split(' ');
      return entry.map((item) => item.replaceAll("'", '')).toList();
    }).toList();
  }

  void getDataFirebase() async {
    final snapshot = await ref.child('loker/1234/historyLoker/$uid').get();
    if (snapshot.exists) {
      dataList = cleanString(snapshot.child("device").value.toString());
      dataList2 = cleanString(snapshot.child("status").value.toString());
    } else {
      print('No data available.');
    }
  }

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    try {
      Timer(const Duration(milliseconds: 500), () {
        completer.complete();
        setState(() {
          getDataFirebase();
        });
      });
      return completer.future.then<void>((_) {});
    } catch (error) {
      print("error");
    }
    return completer.future.then<void>((_) {});
  }

  IconData getLogoDevice(String data, data2) {
    if (data2 == "tertutup") {
      return FontAwesomeIcons.doorClosed;
    } else if (data == "mobile") {
      return FontAwesomeIcons.mobileRetro;
    } else {
      return FontAwesomeIcons.towerBroadcast;
    }
  }

  @override
  void initState() {
    getDataFirebase();
    Future.delayed(const Duration(microseconds: 1000), () {
      // setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LiquidPullToRefresh(
        height: 50,
        color: lightBrown,
        springAnimationDurationInMilliseconds: 500,
        animSpeedFactor: 3,
        showChildOpacityTransition: false,
        onRefresh: _handleRefresh,
        child: ListView.builder(
            itemCount: min(dataList.length, dataList2.length),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  (index == 0)
                      ? Container(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Text(
                            "History",
                            style: text_18_700,
                          ))
                      : const SizedBox(),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 10.0, left: 20.0, right: 20.0),
                    padding: EdgeInsets.only(right: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    decoration: cardContainer,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: FaIcon(
                              getLogoDevice(
                                  dataList[index][1], dataList2[index][1]),
                              color: textH1,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Loker ${dataList2[index][1]}",
                                style: text_14_500,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    getDateFromUnixTime(dataList2[index][0]),
                                    style: text_12_500,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    getTimeFromUnixTime(dataList2[index][0]),
                                    style: text_12_500,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                            onTap: () async {
                              String idx = dataList[index][0];
                              print(dataList[index][0]);
                              await ref
                                  .child(
                                      "loker/1234/historyLoker/$uid/device/$idx")
                                  .remove();
                              await ref
                                  .child(
                                      "loker/1234/historyLoker/$uid/status/$idx")
                                  .remove();
                              final snackBar = SnackBar(
                                content: Text('Data terhapus'),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: lightBrown,
                                action: SnackBarAction(
                                  label: "refresh",
                                  textColor: Colors.white,
                                  onPressed: () => setState(() {
                                    getDataFirebase();
                                  }),
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              setState(() {
                                getDataFirebase();
                              });
                            },
                            child: FaIcon(
                              FontAwesomeIcons.trashCan,
                              size: 17,
                              color: textH1,
                            ))
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
