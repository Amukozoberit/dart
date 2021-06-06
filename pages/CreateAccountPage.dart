import 'dart:async';

import 'package:flutter/material.dart';
import 'package:newApp/widgets/HeaderWidget.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  String username;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext parentContext) {
    //return Text("Here goes Create Account Page");
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context, strTitle: 'Settings', disapearBackButton: true),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 26.0),
            child: Center(
                child: Text(
              'set up a username',
              style: TextStyle(fontSize: 26.0),
            )),
          ),
          Padding(
              padding: EdgeInsets.all(17),
              child: Container(
                child: Form(
                    key: _formKey,
                    autovalidate: true,
                    child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        validator: (val) {
                          if (val.trim().length < 5 || val.isEmpty) {
                            return 'username is very short';
                          } else if (val.trim().length > 15 || val.isEmpty) {
                            return 'username is very short';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) {
                          username = val;
                        },
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'username',
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: 'must be atleast 5 characters',
                          hintStyle: TextStyle(color: Colors.grey),
                        ))),
              )),
          GestureDetector(
            onTap: submitusername,
            child: Container(
                height: 55.0,
                width: 36.0,
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text('proceed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      )),
                )),
          ),
        ],
      ),
    );
  }

  void submitusername() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      SnackBar snackBar = SnackBar(content: Text("welcome " + username));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      Timer(Duration(seconds: 4), () {
        Navigator.pop(context, username);
      });
    }
  }
}
