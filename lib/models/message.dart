import 'dart:convert';

class MessageModel {
  MessageModel contactFromJson(String str) {
    final jsonData = json.decode(str);
    return MessageModel.fromJSON(jsonData);
  }

  String contactToJson(MessageModel data) {
    final dyn = data.toMap();
    return json.encode(dyn);
  }

  String id;
  String message;
  String from;
  DateTime timestamp;

  MessageModel({this.id, this.message, this.from, this.timestamp});

  factory MessageModel.fromJSON(Map<String, dynamic> parsedJSON) {
    return MessageModel(
      id: parsedJSON['id'],
      message: parsedJSON['message'],
      from: parsedJSON['from'],
      timestamp: DateTime.parse(parsedJSON['timestamp']),
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "message": message,
        "from": from,
        "timestamp": timestamp.toIso8601String(),
      };
}
