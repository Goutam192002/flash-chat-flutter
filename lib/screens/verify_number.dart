import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/resolvers/user_resolver.dart';
import 'package:flash_chat/screens/chats_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyNumberScreen extends StatefulWidget {
  static final String id = 'verify_number';
  VerifyNumberScreen(this.verificationId);

  final String verificationId;

  @override
  _VerifyNumberScreenState createState() =>
      _VerifyNumberScreenState(verificationId);
}

class _VerifyNumberScreenState extends State<VerifyNumberScreen> {
  _VerifyNumberScreenState(this.verificationId);

  final String verificationId;
  bool showSpinner = false;
  var onTapRecogniser;
  bool hasError = false;
  String otp = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  verifyOTP() async {
    try {
      AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: verificationId, smsCode: otp);
      await _auth.signInWithCredential(credential);
      Navigator.pushNamed(context, ChatsScreen.id);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    onTapRecogniser = TapGestureRecognizer()
      ..onTap = () {
        verifyOTP();
      };
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                      child: Text("Enter the OTP received"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: PinCodeTextField(
                      length: 6,
                      obsecureText: false,
                      animationType: AnimationType.fade,
                      animationDuration: Duration(milliseconds: 300),
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        activeColor: Colors.black54,
                        inactiveColor: Colors.black12,
                        borderWidth: 1,
                      ),
                      textInputType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          otp = value;
                        });
                      },
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 18),
                child: RoundedButton(
                  color: Colors.lightBlueAccent,
                  onPressed: () {
                    setState(() {
                      showSpinner = true;
                    });
                    AuthCredential _credential =
                        PhoneAuthProvider.getCredential(
                            verificationId: verificationId, smsCode: otp);
                    _auth.signInWithCredential(_credential).then((value) {
                      resolveUser(context, value.user);
                    }).catchError((e) {
                      print(e);
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
