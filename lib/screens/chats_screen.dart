import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/chat_item.dart';
import 'package:flutter/material.dart';

class ChatsScreen extends StatelessWidget {
  static const id = 'chats';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    _auth.currentUser().then((value) {
      print(value.uid);
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: 9,
          itemBuilder: (context, position) => ChatItem(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
