import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/screens/chats_screen.dart';
import 'package:flash_chat/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void resolveUser(BuildContext context, String uid) async {
  Firestore _firestore = Firestore.instance;
  DocumentSnapshot userProfile =
      await _firestore.collection('users').document(uid).get();
  if (!userProfile.exists) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen(uid)),
    );
    return;
  }
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ChatsScreen(),
    ),
  );
}
