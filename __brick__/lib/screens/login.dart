import 'package:flutter/material.dart';

import '../widgets/oauth.dart';
import '../widgets/or_seperator.dart';
import '../widgets/email.dart';
import '../widgets/phone.dart';
import '../widgets/passkey.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent resizing when keyboard appears
      body: Padding(
        padding: const EdgeInsets.all(42),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Log in or sign up',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  OAuthButtons(),
                  OrSeperator(),
                  EmailInput(),
                  OrSeperator(),
                  PhoneNumberInput(),
                  OrSeperator(),
                  PasskeyInput(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
