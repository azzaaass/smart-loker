import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tubes_iot/auth/auth_service.dart';
import 'package:tubes_iot/screen/my_home.dart';
import 'package:tubes_iot/screen/register_screen.dart';
import 'package:tubes_iot/style/color.dart';
import 'package:tubes_iot/style/text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    bool isKeyboardVisible = mediaQuery.viewInsets.bottom > 0;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: brown,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  flex: isKeyboardVisible ? 2 : 5,
                  child: Container(
                    width: mediaQuery.size.width,
                    color: brown,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: isKeyboardVisible ? 100 : 70,
                              child: Image.asset(
                                  "assets/images/urban-fill-1152.png"),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Visibility(
                              visible: !isKeyboardVisible,
                              child: Text(
                                "Welcome,",
                                style: text_25_600_white,
                              ),
                            ),
                            Visibility(
                              visible: !isKeyboardVisible,
                              child: Text(
                                "Sign in to continue",
                                style: text_14_600_white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            width: mediaQuery.size.width,
                            child: Opacity(
                                opacity: 0.05,
                                child: Image.asset(
                                  "assets/images/pattern.png",
                                  fit: BoxFit.cover,
                                )))
                      ],
                    ),
                  )),
              Expanded(
                  flex: 6,
                  child: Container(
                    padding: EdgeInsets.only(top: 40),
                    width: mediaQuery.size.width,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: mediaQuery.size.width / 1.2,
                          child: TextField(
                            controller: _emailController,
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
                        const SizedBox(
                          height: 30.0,
                        ),
                        SizedBox(
                          width: mediaQuery.size.width / 1.2,
                          child: TextField(
                            controller: _passwordController,
                            obscureText: !isVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Tulis password disini',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: brown), // Atur warna border
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isVisible = !isVisible;
                                    });
                                  },
                                  icon: FaIcon(
                                    isVisible
                                        ? FontAwesomeIcons.eye
                                        : FontAwesomeIcons.eyeSlash,
                                    size: 18,
                                  )),
                            ),
                            style: text_14_500,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () async {
                            final message = await AuthService().login(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );

                            if (message == 'Login Success') {
                              // Navigasi ke halaman setelah login berhasil
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyHome(),
                                  ));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(message ?? 'An error occurred'),
                                ),
                              );
                            }
                          },
                          child: Container(
                            height: 45,
                            width: mediaQuery.size.width / 1.2,
                            decoration: BoxDecoration(
                              color: brown,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                                child: Text(
                              "Login",
                              style: text_14_600_white,
                            )),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RegisterScreen(), // Ganti dengan nama halaman registrasi Anda
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'don\'t have an account? ',
                                style: text_12_300,
                              ),
                              Text(
                                'Register',
                                style: text_12_500,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        )
        );
  }
}
