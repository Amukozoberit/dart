import 'package:flutter/material.dart';
import 'HomePage.dart';

class SignOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Out'),
        centerTitle: true,
      ),
      body: SimpleDialog(
        children: [
          SimpleDialogOption(
            child: Padding(
              padding: EdgeInsets.all(35.0),
              child: ListTile(
                leading: RaisedButton.icon(
                  icon: Icon(Icons.lock),
                  label: Text("Log Out"),
                  onPressed: () {
                    logout();
                  },
                ),
              ),
            ),
          ),
          SimpleDialogOption(
           
            child: Padding(
              padding: EdgeInsets.all(35.0),
              
              child: ListTile(
                leading: RaisedButton.icon(
                  icon: Icon(Icons.lock),
                  label: Text("cancel"),
                  onPressed: () {
                    logout();
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  logout() {
    gSignIn.signOut();
  }
}
