import 'dart:convert';

class ContactModel {
  ContactModel contactFromJson(String str) {
    final jsonData = json.decode(str);
    return ContactModel.fromJSON(jsonData);
  }

  String contactToJson(ContactModel data) {
    final dyn = data.toMap();
    return json.encode(dyn);
  }

  int id;
  String uid;
  String name;
  String mobileNumber;
  String lastMessage;
  String lastSeen;
  String profilePictureUrl;
  String status;
  String conversationId;

  ContactModel({
    this.id,
    this.uid,
    this.name,
    this.mobileNumber,
    this.lastMessage,
    this.lastSeen,
    this.profilePictureUrl,
    this.conversationId,
    this.status,
  });

  factory ContactModel.fromJSON(Map<String, dynamic> parsedJSON) {
    return ContactModel(
      id: parsedJSON['id'],
      uid: parsedJSON['uid'],
      name: parsedJSON['name'],
      mobileNumber: parsedJSON['mobile_number'],
      lastMessage: parsedJSON['last_message'],
      lastSeen: parsedJSON['last_seen'],
      profilePictureUrl: parsedJSON['profile_picture_url'],
      conversationId: parsedJSON['conversation_id'],
      status: parsedJSON['status'],
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "uid": uid,
        "name": name,
        "mobile_number": mobileNumber,
        "last_message": lastMessage,
        "last_seen": lastSeen,
        "profile_picture_url": profilePictureUrl,
        "conversation_id": conversationId,
        "status": status
      };
}
