import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chats_screen.dart';
import 'package:flash_chat/screens/terms_and_conditions.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static final String id = 'splash_screen';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          sleep(Duration(seconds: 5));
          FirebaseUser user = snapshot.data;
          if (user == null) {
            return TermsAndConditions();
          }
          return ChatsScreen();
        } else {
          return SplashScreenContent();
        }
      },
    );
  }
}

class SplashScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'images/logo.png',
              ),
              Text(
                "Chat App",
                style: TextStyle(
                  fontSize: 48,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
