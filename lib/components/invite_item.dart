import 'package:flutter/material.dart';

class InviteItem extends StatelessWidget {
  const InviteItem({Key key, this.profilePicture, this.name}) : super(key: key);

  final profilePicture;
  final name;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
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
                            InviteButton(),
                          ],
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
    );
  }
}

class InviteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {},
      color: Colors.lightBlueAccent,
      child: Text(
        "INVITE",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
