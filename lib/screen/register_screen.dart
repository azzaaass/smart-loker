import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tubes_iot/auth/auth_service.dart';
import 'package:tubes_iot/screen/login_screen.dart';
import 'package:tubes_iot/style/color.dart';
import 'package:tubes_iot/style/text.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
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
                  flex: isKeyboardVisible ? 1 : 3,
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
                              width: isKeyboardVisible ? 40 : 70,
                              child: Image.asset(
                                  "assets/images/urban-fill-1152.png"),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Visibility(
                              visible: !isKeyboardVisible,
                              child: Text(
                                "Register,",
                                style: text_25_600_white,
                              ),
                            ),
                            Visibility(
                              visible: !isKeyboardVisible,
                              child: Text(
                                "Enter your data",
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
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              hintText: 'Type username here',
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
                          height: 20.0,
                        ),
                        SizedBox(
                          width: mediaQuery.size.width / 1.2,
                          child: TextField(
                            controller: _phoneNumberController,
                            decoration: InputDecoration(
                              labelText: 'Mobile number',
                              hintText: 'Type mobile number here',
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
                          height: 20.0,
                        ),
                        SizedBox(
                          width: mediaQuery.size.width / 1.2,
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Type email here',
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
                          height: 20.0,
                        ),
                        SizedBox(
                          width: mediaQuery.size.width / 1.2,
                          child: TextField(
                            controller: _passwordController,
                            obscureText: !isVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Type password here',
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
                            final message = await AuthService().register(
                              username: _usernameController.text,
                              phoneNumber: _phoneNumberController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                            );

                            if (message == 'Registration Success') {
                              // Navigasi ke halaman setelah registrasi berhasil
                              Navigator.of(context)
                                  .pop(); // Kembali ke halaman login setelah registrasi berhasil
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
                              "Register",
                              style: text_14_600_white,
                            )),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LoginScreen(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'already have an account? ',
                                style: text_12_300,
                              ),
                              Text(
                                'Login',
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
