import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/providers/database.dart';
import 'package:flash_chat/screens/chats_screen.dart';
import 'package:flash_chat/screens/profile_screen.dart';
import 'package:flash_chat/screens/sync_contacts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void resolveUser(BuildContext context, FirebaseUser user) async {
  Firestore _firestore = Firestore.instance;
  DocumentSnapshot userProfile =
      await _firestore.collection('users').document(user.uid).get();
  if (!userProfile.exists) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen(user)),
    );
    return;
  }
  var contacts = await DatabaseProvider.db.getAllContacts();
  if (contacts.isEmpty) {
    Navigator.pushReplacementNamed(context, SyncContacts.id);
    return;
  }
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ChatsScreen(),
    ),
  );
}
