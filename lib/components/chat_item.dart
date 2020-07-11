import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  const ChatItem(
      {Key key, this.profilePicture, this.name, this.message, this.lastSeen})
      : super(key: key);

  final String profilePicture;
  final String name;
  final String message;
  final String lastSeen;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
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
