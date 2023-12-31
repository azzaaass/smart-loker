import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tubes_iot/style/color.dart';
import 'package:tubes_iot/style/text.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final email = FirebaseAuth.instance.currentUser?.email;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final ref = FirebaseDatabase.instance.ref();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  void getDataFirebaseRealtime() async {
    final snapshot = await ref.child('usersData/$uid').get();
    if (snapshot.exists) {
      usernameController.text = snapshot.child('username').value.toString();
      phoneController.text = snapshot.child('phoneNumber').value.toString();
    } else {
      print('No data available.');
    }
  }

  @override
  void initState() {
    getDataFirebaseRealtime();
    emailController.text = email.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: smoothGrey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                color: whiteBone, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: FaIcon(
                        FontAwesomeIcons.angleLeft,
                        size: 18,
                        color: textH1,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "My Profile",
                        style: text_14_700,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: mediaQuery.size.width / 1.2,
                  child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      hintText: 'Change username?',
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: brown), // Atur warna border
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                    ),
                    style: text_14_500,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: mediaQuery.size.width / 1.2,
                  child: TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone number',
                      hintText: 'Change phone number?',
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: brown), // Atur warna border
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                    ),
                    style: text_14_500,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: mediaQuery.size.width / 1.2,
                  child: TextField(
                    controller: emailController,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: brown), // Atur warna border
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                    ),
                    style: text_14_500,
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () async {
                    await ref.child('usersData/$uid').set({
                      'username' : usernameController.text,
                      'phoneNumber' : phoneController.text,
                    });
                    getDataFirebaseRealtime();
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: orange, borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                      "Update",
                      style: text_14_600_white,
                    )),
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
