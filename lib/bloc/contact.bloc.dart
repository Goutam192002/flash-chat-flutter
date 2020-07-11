import 'dart:async';

import 'package:flash_chat/models/contact.dart';
import 'package:flash_chat/providers/database.dart';

class ContactsBloc {
  ContactsBloc() {
    getAllContacts();
  }

  final _contactsController = StreamController<List<ContactModel>>.broadcast();
  Stream<List<ContactModel>> get contacts => _contactsController.stream;

  _dispose() {
    _contactsController.close();
  }

  getAllContacts() async {
    _contactsController.sink.add(await DatabaseProvider.db.getAllContacts());
  }

  addContact(ContactModel contact) async {
    DatabaseProvider.db.createNewContact(contact);
    getAllContacts();
  }

  addBulkContacts(List<ContactModel> contacts) async {
    for (ContactModel contact in contacts) {
      DatabaseProvider.db.createNewContact(contact);
    }
    getAllContacts();
  }

  searchContacts(String query) async {
    if (query != null) {
      _contactsController.sink
          .add(await DatabaseProvider.db.getContactsByName(query));
    }
  }
}
