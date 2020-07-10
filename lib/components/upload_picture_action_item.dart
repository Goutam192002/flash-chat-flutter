import 'package:flutter/material.dart';

class UploadPictureActionItem extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final String leading;

  UploadPictureActionItem({this.onTap, this.icon, this.leading});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(icon),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(leading),
            )
          ],
        ),
      ),
    );
  }
}
