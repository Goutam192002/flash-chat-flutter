import 'package:flash_chat/components/image_cropper.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen(this.uid);

  final String uid;
  static final String id = 'profile_screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState(uid);
}

class _ProfileScreenState extends State<ProfileScreen> {
  _ProfileScreenState(this.uid);

  final String uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ImageCapture(),
    );
  }
}
