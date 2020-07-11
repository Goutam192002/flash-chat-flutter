import 'dart:io';

import 'package:flash_chat/models/contact.dart';
import 'package:flash_chat/models/message.dart';
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
        await db.execute("CREATE TABLE Contacts ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "uid TEXT,"
            "name TEXT,"
            "mobile_number TEXT,"
            "last_message TEXT,"
            "last_seen TEXT,"
            "profile_picture_url TEXT,"
            "conversation_id TEXT,"
            "status TEXT"
            ");");
        await db.execute("CREATE TABLE Messages("
            "id TEXT PRIMARY KEY,"
            "message TEXT,"
            "from TEXT,"
            "timestamp TEXT"
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

  updateContact(var update) async {
    final db = await database;
    var raw = db.update("Contacts", update);
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
      where: "name LIKE ?",
      whereArgs: ['%$query%'],
    );
    return response.isNotEmpty
        ? response.map((contact) => ContactModel.fromJSON(contact)).toList()
        : [];
  }

  Future<ContactModel> getConversation(String conversationId) async {
    final db = await database;
    var response = await db.query("Contacts",
        where: "conversation_id = ?", whereArgs: [conversationId]);
    return ContactModel.fromJSON(response.first);
  }

  Future<List<ContactModel>> getAllContacts() async {
    final db = await database;
    var response = await db.query("Contacts");
    List<ContactModel> contacts = response.isNotEmpty
        ? response.map((contact) => ContactModel.fromJSON(contact)).toList()
        : [];
    return contacts;
  }

  createNewMessage(MessageModel message) async {
    final db = await database;
    var raw = db.insert(
      "Messages",
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  updateMessage(MessageModel message) async {
    final db = await database;
    var raw = db.update("Messages", {
      'id': message.id,
      'message': message.message,
      'timestamp': message.timestamp.toIso8601String()
    });
    return raw;
  }

  deleteMessage(String id) async {
    final db = await database;
    return db.delete("Messages", where: 'id = ?', whereArgs: [id]);
  }

  Future<List<MessageModel>> getConversationMessages(String id) async {
    final db = await database;
    var response = await db.query(
      "Messages",
      where: "id = ?",
      whereArgs: [id],
    );
    return response.isNotEmpty
        ? response.map((message) => MessageModel.fromJSON(message)).toList()
        : [];
  }
}
