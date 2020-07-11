import 'package:flash_chat/bloc/contact.bloc.dart';
import 'package:flash_chat/components/chat_item.dart';
import 'package:flash_chat/components/invite_item.dart';
import 'package:flash_chat/models/contact.dart';
import 'package:flutter/material.dart';

class UserSearchDelegate extends SearchDelegate {
  final ContactsBloc _contactsBloc = ContactsBloc();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
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
          if (contacts.length > 0) {
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                ContactModel contact = contacts[index];
                if (contact.uid == null) {
                  return InviteItem(
                    name: contact.name,
                  );
                } else {
                  return ChatItem(
                    name: contact.name,
                    message: contact.lastMessage != null
                        ? contact.lastMessage
                        : contact.status,
                    profilePicture: contact.profilePictureUrl,
                  );
                }
              },
            );
          }
          return Column(
            children: <Widget>[
              Text(
                "No Results Found.",
              ),
            ],
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
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
          if (contacts.length > 0) {
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                ContactModel contact = contacts[index];
                if (contact.uid == null) {
                  return InviteItem(
                    name: contact.name,
                  );
                } else {
                  return ChatItem(
                    name: contact.name,
                    profilePicture: contact.profilePictureUrl,
                  );
                }
              },
            );
          }
          return Column(
            children: <Widget>[
              Text(
                "No Results Found.",
              ),
            ],
          );
        }
      },
    );
  }
}
