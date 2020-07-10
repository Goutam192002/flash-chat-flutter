import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/chat_item.dart';
import 'package:flash_chat/components/user_search_delegate.dart';
import 'package:flutter/material.dart';

class ChatsScreen extends StatefulWidget {
  static const id = 'chats';

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Iterable<Contact> contacts;
  String query;

  @override
  Widget build(BuildContext context) {
    _auth.currentUser().then((value) {
      print(value.uid);
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: UserSearchDelegate(),
              );
            },
          )
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: 0,
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
