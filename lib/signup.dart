//import 'package:flutter/gestures.dart';
import 'package:designapp/auth.dart';
import 'package:designapp/utils/loading_indicator.dart';
import 'package:designapp/repository/authentication.dart';
import 'package:designapp/repository/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:designapp/homepage.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _signupFormKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        body: CustomPaint(
          painter: BackgroundPaint(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                      color: Colors.white70,
                      boxShadow: [
                        BoxShadow(
                            offset: Offset.zero,
                            blurRadius: 2,
                            spreadRadius: 3,
                            color: Colors.white10),
                      ]),
                  constraints: BoxConstraints(maxHeight: 300, maxWidth: 400),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Form(
                        key: _signupFormKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: _emailTextController,
                              focusNode: _focusEmail,
                              validator: (value) =>
                                  Validator.validateEmail(email: value),
                              decoration: InputDecoration(
                                labelText: 'email',
                                labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25),
                                  ),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _passwordTextController,
                              focusNode: _focusPassword,
                              validator: (value) =>
                                  Validator.validatePassword(password: value),
                              decoration: InputDecoration(
                                labelText: 'password',
                                labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(25),
                                    bottomRight: Radius.circular(25),
                                  ),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                              ),
                              obscureText: true,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            _isProcessing
                                ? LoadingIndicator()
                                : GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        _isProcessing = true;
                                      });
                                      if (_signupFormKey.currentState!
                                          .validate()) {
                                        User? user = await Authentication
                                            .registerUsingEmailPassword(
                                                email:
                                                    _emailTextController.text,
                                                password:
                                                    _passwordTextController
                                                        .text);

                                        setState(() {
                                          _isProcessing = false;
                                        });
                                        if (user != null) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  HomePage(
                                                user: user,
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25),
                                        ),
                                        color: Color(0xff8705bf),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(0, 3),
                                              blurRadius: 3,
                                              spreadRadius: 2,
                                              color: Color(0xffbf63d8)),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Sign up'.toUpperCase(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
