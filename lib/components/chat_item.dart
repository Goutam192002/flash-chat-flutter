import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/bloc/contact.bloc.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  ChatItem({
    Key key,
    this.profilePicture,
    this.name,
    this.message,
    this.lastSeen,
    this.conversationId,
    this.user,
    this.toUser,
  }) : super(key: key);

  final Firestore _firestore = Firestore.instance;
  final ContactsBloc _contactsBloc = ContactsBloc();
  final FirebaseUser user;
  final String toUser;
  final String profilePicture;
  final String name;
  final String message;
  final String lastSeen;
  final String conversationId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        print(conversationId);
        if (conversationId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                conversationId: conversationId,
              ),
            ),
          );
          return;
        }
        DocumentReference conversation =
            await _firestore.collection('conversations').add({
          'participants': [toUser, user.uid]
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              conversationId: conversation.documentID,
            ),
          ),
        );
        _contactsBloc
            .updateContact({'conversation_id': conversation.documentID});
      },
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 8, top: 8, bottom: 8),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey,
                backgroundImage: profilePicture != null
                    ? NetworkImage(
                        profilePicture,
                      )
                    : AssetImage('images/default-profile-image.png'),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (lastSeen != null)
                                Text(
                                  lastSeen,
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                )
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            message,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.black12,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
