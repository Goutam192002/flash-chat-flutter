import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/bloc/contact.bloc.dart';
import 'package:flash_chat/components/chat_item.dart';
import 'package:flash_chat/components/user_search_delegate.dart';
import 'package:flash_chat/models/contact.dart';
import 'package:flutter/material.dart';

class ChatsScreen extends StatefulWidget {
  static const id = 'chats';

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ContactsBloc _contactsBloc = ContactsBloc();

  FirebaseUser currentUser;
  Iterable<Contact> contacts;
  String query;

  @override
  Widget build(BuildContext context) {
    _auth.currentUser().then((value) {
      currentUser = value;
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
                delegate: UserSearchDelegate(currentUser),
              );
            },
          )
        ],
      ),
      body: Container(
          child: StreamBuilder(
        stream: _contactsBloc.contacts,
        builder: (context, AsyncSnapshot<Object> results) {
          if (!results.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          } else {
            List contacts = results.data;
            contacts = contacts.where((element) => element.lastMessage != null).toList();
            if (contacts.length > 0) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  ContactModel contact = contacts[index];
                  return ChatItem(
                    name: contact.name,
                    message: contact.lastMessage,
                    profilePicture: contact.profilePictureUrl,
                    lastSeen: contact.lastSeen,
                    user: currentUser,
                    toUser: contact.uid,
                  );
                },
              );
            }
            return Container();
          }
        },
      )),
    );
  }
}
