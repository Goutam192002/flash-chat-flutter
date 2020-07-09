import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/resolvers/user_resolver.dart';
import 'package:flash_chat/screens/verify_number.dart';
import 'package:flutter/material.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String phoneNumber;
  String phoneNumberIsoCode = 'IN';
  String finalPhoneNumber;
  bool showSpinner = false;

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      phoneNumber = number;
      phoneNumberIsoCode = isoCode;
      finalPhoneNumber = internationalizedPhoneNumber;
    });
  }

  Future loginUser(String mobileNumber, BuildContext context) {
    setState(() {
      showSpinner = true;
    });
    _auth.verifyPhoneNumber(
        phoneNumber: mobileNumber,
        timeout: Duration(seconds: 30),
        verificationCompleted: (AuthCredential authCredential) {
          _auth.signInWithCredential(authCredential).then((value) {
            resolveUser(context, value.user.uid);
          }).catchError((e) {
            print(e);
            setState(() {
              showSpinner = false;
            });
          });
        },
        verificationFailed: (AuthException exception) {
          print(exception.message);
          setState(() {
            showSpinner = false;
          });
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyNumberScreen(verificationId),
            ),
          );
        },
        codeAutoRetrievalTimeout: null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 18),
                    child: Center(
                      child: Text(
                        "Let's verify your mobile Number",
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 18),
                    child: InternationalPhoneInput(
                      onPhoneNumberChange: onPhoneNumberChange,
                      initialPhoneNumber: phoneNumber,
                      initialSelection: phoneNumberIsoCode,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 18),
                child: RoundedButton(
                  color: Colors.lightBlueAccent,
                  onPressed: () async {
                    print(finalPhoneNumber);
                    loginUser(finalPhoneNumber, context).then((value) {
                      print(value);
                    });
                  },
                  title: 'Next',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
