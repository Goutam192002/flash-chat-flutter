import 'package:contacts_service/contacts_service.dart';
import 'package:flash_chat/components/chat_item.dart';
import 'package:flash_chat/components/invite_item.dart';
import 'package:flutter/material.dart';

class UserSearchDelegate extends SearchDelegate {
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
    Future<Iterable<Contact>> results =
        ContactsService.getContacts(query: query, withThumbnails: false);
    return FutureBuilder(
      builder: (context, AsyncSnapshot<Iterable<Contact>> results) {
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
        } else if (results.data.length != 0) {
          List contacts = results.data.toList();
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              Contact contact = contacts[index];
              return ChatItem(
                name: contact.displayName,
              );
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
      },
      future: results,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Future<Iterable<Contact>> results =
        ContactsService.getContacts(query: query, withThumbnails: false);
    return FutureBuilder(
      builder: (context, AsyncSnapshot<Iterable<Contact>> results) {
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
        } else if (results.data.length != 0) {
          List contacts = results.data.toList();
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              Contact contact = contacts[index];
              // TODO: check if contact exists
              return InviteItem(
                name: contact.displayName,
              );
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
      },
      future: results,
    );
  }
}
