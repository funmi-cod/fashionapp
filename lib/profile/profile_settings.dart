import 'dart:io';

import 'package:designapp/repository/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Settings extends StatefulWidget {
  final User user;
  const Settings({required this.user});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  File? _avatarImage;

  final picker = ImagePicker();

  // create two functions to pick image from gallery/camera

  // create a future function. store the result in a variable of File
  // as it will return the image Path
  Future pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    setState(() {
      _avatarImage = File(pickedFile!.path);
    });
  }

  Future pickImageFromCamera() async {
    XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    setState(() {
      _avatarImage = pickedFile as File;
    });
  }

  var _currentUser;
  bool _isSendingVerification = false;

  @override
  void initState() {
    // TODO: implement initState
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.arrowLeft,
            color: Color(0xff8705bf),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          color: Colors.white,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () => _displayPicker(context),
                child: CircleAvatar(
                  radius: 75,
                  // ignore: unnecessary_null_comparison
                  child: _avatarImage != null
                      ? ClipOval(
                          child: SizedBox(
                            width: 120,
                            height: 120,
                            child: Image.file(
                              _avatarImage!,
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          width: 100,
                          height: 100,
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.grey.shade400,
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '${_currentUser.email}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(
                height: 16,
              ),
              _currentUser.emailVerified
                  ? Text(
                      'Email verified',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.green),
                    )
                  : Text(
                      'Email not verified',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.red),
                    ),
              SizedBox(
                height: 16,
              ),
              _isSendingVerification
                  ? CircularProgressIndicator()
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              _isSendingVerification = true;
                            });
                            await _currentUser.sendEmailVerification();
                            setState(() {
                              _isSendingVerification = false;
                            });
                          },
                          child: Text(
                            'Verify email',
                            style: TextStyle(
                                color: Color(0xff8705bf),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        IconButton(
                          onPressed: () async {
                            User? user =
                                await Authentication.refreshUser(_currentUser);
                            if (user != null) {
                              setState(() {
                                _currentUser = user;
                              });
                            }
                          },
                          icon: Icon(
                            Icons.refresh_rounded,
                            color: Color(0xff8705bf),
                          ),
                        ),
                      ],
                    ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // create a function for displaying a bottom sheet for the user
  // To choose the option of camera or gallery.
  void _displayPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Gallery'),
                    onTap: () {
                      pickImageFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    pickImageFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
