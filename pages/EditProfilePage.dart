import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:newApp/models/user.dart';
import 'package:newApp/pages/HomePage.dart';
import 'package:newApp/widgets/ProgressWidget.dart';


class EditProfilePage extends StatefulWidget {
  final String currentOnlineUserId;

  const EditProfilePage({Key key, this.currentOnlineUserId}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController profileNameTextEditingController =
      TextEditingController();
  TextEditingController bioTextEditingController = TextEditingController();
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  User user;
  bool _profileNameValid = true;
  bool _bioValid = true;
  Column createPRofileNameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 13.0),
          child: Text(
            'Profile name',
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold),
          ),
        ),
        TextField(
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
            controller: profileNameTextEditingController,
            decoration: InputDecoration(
              hintText: 'write profile name',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              border: OutlineInputBorder(),
              //labelText: 'search here',
              labelStyle: TextStyle(fontSize: 15.0),
              //hintText: '',
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              errorText: _profileNameValid ? null : 'Profile name short',
            )),
      ],
    );
  }

  Column createBioTextFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 13.0),
          child: Text(
            'Bio',
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold),
          ),
        ),
        TextField(
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
            controller: bioTextEditingController,
            decoration: InputDecoration(
              hintText: 'Bio',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              border: OutlineInputBorder(),
              //labelText: 'search here',
              labelStyle: TextStyle(fontSize: 15.0),
              //hintText: '',
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              errorText: _bioValid ? null : 'bio is too long ',
            )),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    getAndDisplayUserInfo();
  }

  getAndDisplayUserInfo() async {
    setState(() {
      loading = true;
    });
    DocumentSnapshot documentSnapshot =
        await usersReference.document(widget.currentOnlineUserId).get();
    user = User.fromDocument(documentSnapshot);
    profileNameTextEditingController.text = user.profileName;
    bioTextEditingController.text = user.bio;
    setState(() {
      loading = false;
    });
  }

  updateUserData() {
    setState(() {
      profileNameTextEditingController.text.trim().length < 3 ||
              profileNameTextEditingController.text.isEmpty
          ? _profileNameValid = false
          : _profileNameValid = true;

      bioTextEditingController.text.trim().length > 110
          ? _bioValid = false
          : _bioValid = true;
    });
    if (_bioValid && _profileNameValid) {
      usersReference.document(widget.currentOnlineUserId).updateData({
        "profileName": profileNameTextEditingController.text,
        "bio": bioTextEditingController.text,
      });
      SnackBar successSnackBar =
          SnackBar(content: Text('profile updated sucesfully'));
      _scaffoldGlobalKey.currentState.showSnackBar(successSnackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldGlobalKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Edit Profile',
          style: TextStyle(
              fontSize: 16.0, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.done),
              color: Colors.white,
              // size:
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
      body: loading
          ? circularProgress()
          : ListView(
              children: [
                Container(
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: 60.0, bottom: 7.0),
                          child: CircleAvatar(
                            radius: 52.0,
                            backgroundImage:
                                CachedNetworkImageProvider(user.url),
                          )),
                      Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              createPRofileNameTextField(),
                              createBioTextFormField(),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.all(16.0),
                          child: RaisedButton(
                            child: Text(
                              'update',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: updateUserData,
                          )),
                      Padding(
                          padding: EdgeInsets.all(50.0),
                          child: RaisedButton(
                            child: Text(
                              'logout',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            color: Colors.red,
                            onPressed: logOutUser,
                          )),
                    ],
                  ),
                )
              ],
            ),
    );
    //Text('Here goes Edit Profile Page');
  }

  logOutUser() async {
    gSignIn.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomePage();
    }));
  }
}
