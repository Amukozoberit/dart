import 'package:flutter/material.dart';
import 'package:newApp/pages/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:newApp/shop-in/components/constants.dart';
//import 'package:newApp/shop-in/lib/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firestore.instance.settings(timestampsInSnapshotsEnabled: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cookHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blueGrey[900],
        dialogBackgroundColor: Colors.black,
        primarySwatch: Colors.grey,
        cardColor: Colors.white70,
        accentColor: Colors.grey,
        
      ),
      home: Scaffold(
        /*appBar: AppBar(
             title: Text(
            'Welcome to CookHub ',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,*/

        body:
            /*Center(
          child: Text(
            'Hello World',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30.0,
            ),
          ),
        ),*/
            HomePage(),
      ),
    );
  }
}
