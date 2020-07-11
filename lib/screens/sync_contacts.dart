import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flash_chat/bloc/contact.bloc.dart';
import 'package:flash_chat/models/contact.dart';
import 'package:flutter/material.dart';

class SyncContacts extends StatefulWidget {
  static final String id = 'sync_contacts';
  @override
  _SyncContactsState createState() => _SyncContactsState();
}

class _SyncContactsState extends State<SyncContacts> {
  Firestore _firestore = Firestore.instance;
  ContactsBloc _contactsBloc = ContactsBloc();

  syncContacts() async {
    final contacts = await ContactsService.getContacts();
    List<ContactModel> insert = [];
    for (Contact contact in contacts) {
      for (var phone in contact.phones) {
        try {
          var result = await _firestore
              .collection('users')
              .where('mobile_number',
                  isEqualTo: phone.value.replaceAll(' ', ''))
              .getDocuments();
          ContactModel contactObject = ContactModel(
            name: contact.displayName,
            uid: result.documents.first.documentID,
            mobileNumber: result.documents.first.data['mobile_number'],
            profilePictureUrl: result.documents.first.data['profile_picture'],
            status: result.documents.first.data['last_seen'],
          );
          insert.add(contactObject);
        } catch (e) {
          print(e);
        }
      }
    }
    _contactsBloc.addBulkContacts(insert);
  }

  @override
  void initState() {
    syncContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Syncing Contacts",
                style: TextStyle(
                  fontSize: 32,
                ),
              ),
              LinearProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
