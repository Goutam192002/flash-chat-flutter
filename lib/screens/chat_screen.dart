import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/bloc/contact.bloc.dart';
import 'package:flash_chat/components/message_bubble.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/models/contact.dart';
import 'package:flutter/material.dart';

final _fireStore = Firestore.instance;
FirebaseUser currentUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat';
  final String conversationId;

  ChatScreen({this.conversationId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final messageTextController = TextEditingController();
  final ContactsBloc _contactsBloc = ContactsBloc();
  ContactModel _conversation;
  String message;

  @override
  void initState() {
    this.getCurrentUser();
    this.getConversation();
    super.initState();
  }

  getConversation() async {
    ContactModel conversation =
        await _contactsBloc.getConversationById(widget.conversationId);
    setState(() {
      _conversation = conversation;
    });
  }

  getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      currentUser = user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: _conversation.profilePictureUrl != null
                  ? NetworkImage(_conversation.profilePictureUrl)
                  : AssetImage('images/default-profile-iamge.png'),
            ),
            SizedBox(
              width: 8,
            ),
            Text(_conversation.name),
          ],
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      _fireStore.collection('messages').add({
                        'text': message,
                        'sender': currentUser.email,
                        'time': FieldValue.serverTimestamp()
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _fireStore
          .collection('messages')
          .orderBy('time', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.documents.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];
          final messageTime = message.data['time'] as Timestamp;

          final email = currentUser.email;
          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: messageSender == email,
            time: messageTime,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}
