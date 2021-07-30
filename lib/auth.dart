import 'package:designapp/homepage.dart';
import 'package:designapp/utils/loading_indicator.dart';
import 'package:designapp/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:designapp/repository/authentication.dart';
import 'package:designapp/repository/validator.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  Future<FirebaseApp> _inializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(
            user: user,
          ),
        ),
      );
    }
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        body: FutureBuilder(
          future: _inializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                color: Colors.white,
                child: CustomPaint(
                  painter: BackgroundPaint(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Welcome to   ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w200,
                            ),
                            children: [
                              TextSpan(
                                text: '\nFashion Hub',
                                style: TextStyle(
                                    color: Color(0xffbf63d8),
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    height: 1),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                            ],
                          ),
                          constraints:
                              BoxConstraints(maxHeight: 300, maxWidth: 400),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextFormField(
                                      controller: _emailTextController,
                                      // ignore: missing_return
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
                                          Validator.validatePassword(
                                              password: value),
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
                                              _focusEmail.unfocus();
                                              _focusPassword.unfocus();
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  _isProcessing = true;
                                                });
                                                User? user = await Authentication
                                                    .signInUsingEmailPassword(
                                                        email:
                                                            _emailTextController
                                                                .text,
                                                        password:
                                                            _passwordTextController
                                                                .text);
                                                setState(() {
                                                  _isProcessing = false;
                                                });
                                                if (user != null) {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomePage(user: user),
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
                                                  'login'.toUpperCase(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Don\'t have an account?',
                                        style: TextStyle(
                                            color: Color(0xffbf63d8),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w100),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Sign up',
                                            style: TextStyle(
                                                color: Color(0xff8705bf),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        SignUp(),
                                                  ),
                                                );
                                              },
                                          ),
                                        ],
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
              );
            }
            return LoadingIndicator();
          },
        ),
      ),
    );
  }
}

class BackgroundPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    final height = size.height;
    final width = size.width;

    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..color = Color(0xff8705bf);

    Path upperPath = Path();

    upperPath.moveTo(0, height * 0.55);
    upperPath.quadraticBezierTo(
        width * 0.70, height * 0.72, width, height * 0.5);

    upperPath.lineTo(width, 0);
    upperPath.lineTo(0, 0);

    canvas.drawPath(upperPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
