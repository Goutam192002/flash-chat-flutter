import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/components/upload_picture_action_item.dart';
import 'package:flash_chat/screens/chats_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen(this.user);

  final FirebaseUser user;
  static final String id = 'profile_screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState(user);
}

class _ProfileScreenState extends State<ProfileScreen> {
  _ProfileScreenState(this.user);

  File _imageFile;
  String _imageUrl;
  String _name;
  String _status;
  StorageUploadTask _uploadTask;
  bool showSpinner = false;
  bool showSpinnerMain = false;

  final FirebaseUser user;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Firestore _firestore = Firestore.instance;

  @override
  void initState() {
    _storage
        .ref()
        .child('/profile-pictures/${user.uid}.png')
        .getDownloadURL()
        .then((value) {
      setState(() {
        print(value);
        _imageUrl = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        child: SafeArea(
          child: ModalProgressHUD(
            inAsyncCall: showSpinnerMain,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(18),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(64),
                    onTap: showUploadPictureBottomSheet,
                    child: CircleAvatar(
                      backgroundColor: Colors.black45,
                      backgroundImage: _imageUrl != null
                          ? NetworkImage(
                              _imageUrl,
                            )
                          : AssetImage(
                              'images/default-profile-image.png',
                            ),
                      radius: 64,
                      child: ModalProgressHUD(
                        child: Container(),
                        opacity: 0,
                        inAsyncCall: showSpinner,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Name'),
                    onChanged: (value) => _name = value,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Status'),
                    onChanged: (value) => _status = value,
                  ),
                ),
                RoundedButton(
                  color: Colors.blue,
                  title: 'Continue',
                  onPressed: saveUserProfile,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveUserProfile() async {
    try {
      setState(() {
        showSpinnerMain = true;
      });
      await _firestore.collection('users').document(user.uid).setData({
        'mobile_number': user.phoneNumber,
        'profile_picture': _imageUrl,
        'name': _name,
        'status': _status
      });
      Navigator.pushReplacementNamed(context, ChatsScreen.id);
    } catch (e) {
      setState(() {
        showSpinnerMain = false;
      });
      print(e);
    }
  }

  void showUploadPictureBottomSheet() {
    showModalBottomSheet(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) => Wrap(
        children: <Widget>[
          UploadPictureActionItem(
            onTap: () => _pickImage(ImageSource.camera),
            icon: Icons.photo_camera,
            leading: "Take a picture",
          ),
          UploadPictureActionItem(
            onTap: () => _pickImage(ImageSource.gallery),
            icon: Icons.photo_library,
            leading: "Choose from Gallery",
          )
        ],
      ),
    );
  }

  _uploadImage(File image) {
    setState(() {
      showSpinner = true;
    });
    String filePath = 'profile-pictures/${user.uid}.png';
    _uploadTask = _storage.ref().child(filePath).putFile(image);
    _uploadTask.onComplete.then((value) async {
      String downloadUrl = await value.ref.getDownloadURL();
      setState(() {
        _imageUrl = downloadUrl;
        showSpinner = false;
      });
    });
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
    );
    Navigator.pop(context);
    _imageFile = cropped ?? _imageFile;
    _uploadImage(_imageFile);
  }

  Future<void> _pickImage(ImageSource source) async {
    _imageFile = await ImagePicker.pickImage(source: source);
    await _cropImage();
  }
}
