import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/resolvers/user_resolver.dart';
import 'package:flash_chat/screens/terms_and_conditions.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static final String id = 'splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void bootstrap() async {
    FirebaseUser user = await _auth.currentUser();
    if (user == null) {
      Navigator.pushNamed(context, TermsAndConditions.id);
      return;
    }
    resolveUser(context, user);
  }

  @override
  void initState() {
    bootstrap();
    super.initState();
  }

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
              Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
