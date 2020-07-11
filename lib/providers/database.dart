import 'dart:io';

import 'package:flash_chat/models/contact.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  DatabaseProvider._();

  static final DatabaseProvider db = DatabaseProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(
      documentsDirectory.path,
      "application.db",
    );
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        return db.execute("CREATE TABLE Contacts ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "uid TEXT,"
            "name TEXT,"
            "mobile_number TEXT,"
            "last_message TEXT,"
            "last_seen TEXT,"
            "profile_picture_url TEXT,"
            "status TEXT"
            ");");
      },
    );
  }

  createNewContact(ContactModel contact) async {
    final db = await database;
    var raw = db.insert(
      "Contacts",
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  getContact(String uid) async {
    final db = await database;
    var response = await db.query(
      "Contacts",
      where: "uid = ?",
      whereArgs: [uid],
    );
    return response.isNotEmpty ? ContactModel.fromJSON(response.first) : null;
  }

  Future<List<ContactModel>> getContactsByName(String query) async {
    final db = await database;
    var response = await db.query(
      "Contacts",
      where: "name = ?",
      whereArgs: [query],
    );
    return response.isNotEmpty
        ? response.map((contact) => ContactModel.fromJSON(contact)).toList()
        : [];
  }

  Future<List<ContactModel>> getAllContacts() async {
    final db = await database;
    var response = await db.query("Contacts");
    List<ContactModel> contacts = response.isNotEmpty
        ? response.map((contact) => ContactModel.fromJSON(contact)).toList()
        : [];
    return contacts;
  }
}
