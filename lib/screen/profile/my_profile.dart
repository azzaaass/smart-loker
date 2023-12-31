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
  @override
  Widget build(BuildContext context) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: smoothGrey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: whiteBone, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.angleLeft,
                          size: 18,
                          color: textH1,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "My Profile",
                          style: text_14_700,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                          width: mediaQuery.size.width / 1.2,
                          child: TextField(
                            // controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Tulis email disini',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: brown), // Atur warna border
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                            ),
                            style: text_14_500,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
