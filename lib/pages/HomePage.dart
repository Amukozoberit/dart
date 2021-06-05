import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
//import 'package:newApp/chats/chatpage.dart';
//mport 'package:newApp/chats/login.dart';
import 'package:newApp/models/user.dart';
import 'package:newApp/pages/DesignedHome.dart';
import 'package:newApp/pages/Saver.dart';
import 'package:newApp/pages/SignOut.dart';
import 'package:newApp/pages/TimeLinePage.dart';

import 'package:newApp/pages/questions.dart';
import 'package:newApp/pages/CreateAccountPage.dart';
import 'package:newApp/pages/NotificationsPage.dart';
import 'package:newApp/pages/ProfilePage.dart';
import 'package:newApp/pages/SearchPage.dart';
import 'package:newApp/pages/UploadPage.dart';
import 'package:newApp/pages/uploader.dart';
import 'package:newApp/pages/viewpage.dart';
import 'package:newApp/shop-in/src/app.dart';
import 'package:newApp/shop-in/src/home_top_info.dart';
import 'package:newApp/shop-in/src/pages/home.dart';
//import 'package:newApp/ingridients/screens/home.dart';
import 'package:newApp/webrecipes/Homes.dart';
import 'package:newApp/widgets/PostWidget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'TimeLinePage.dart';

final GoogleSignIn gSignIn = GoogleSignIn();
final usersReference = Firestore.instance.collection("users");
final DateTime timestamp = DateTime.now();
SharedPreferences preferences;
User currentUser;
final StorageReference storageReference =
    FirebaseStorage.instance.ref().child('Posts Pictures');
//collection.ref().child('Post Pictures');
final postsReference = Firestore.instance.collection("posts");
final activityFeedReference = Firestore.instance.collection('feed');
final commentsReference = Firestore.instance.collection('comments');
final followersReference = Firestore.instance.collection('userfollowers');
final questionReference = Firestore.instance.collection('Questions');
final followingReference = Firestore.instance.collection('userfollowing');
final timelineReference = Firestore.instance.collection('timeline');
final reviewsReference = Firestore.instance.collection('Reviews');
final savedToStore = Firestore.instance.collection('savedRecipes');

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pagecontroller;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  int getPageIndex = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    pagecontroller = PageController();
    // FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    gSignIn.onCurrentUserChanged.listen((gSigninAccount) {
      controlSignIn(gSigninAccount);
    }, onError: (gError) {
      print('Error Message:' + gError);
    });

    gSignIn
        .signInSilently(suppressErrors: false)
        .then((gSignInAccount) {})
        .catchError((gError) {
      print(gError);
    });
  }

  onTapPageChange(int pageIndex) {
    pagecontroller.animateToPage(pageIndex,
        duration: Duration(milliseconds: 400), curve: Curves.bounceInOut);
  }

  bool isSignedin = false;
  controlSignIn(GoogleSignInAccount signInAccount) async {
    if (signInAccount != null) {
      await saveUserInfoToFireStore();
      setState(() {
        isSignedin = true;
      });
      configureRealTimePushNotifications();
    } else {
      setState(() {
        isSignedin = false;
      });
    }
  }

  configureRealTimePushNotifications() {
    final GoogleSignInAccount gUser = gSignIn.currentUser;
    if (Platform.isIOS) {
      getIosPermissions();
    }
    _firebaseMessaging.getToken().then((token) {
      usersReference
          .document(gUser.id)
          .updateData({"androidNotificationToken": token});
    });
    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> msg) async {
      final String recipientId = msg["data"]["recepient"];
      final String body = msg["notification"]["body"];

      if (recipientId == gUser.id) {
        SnackBar snackBar = SnackBar(
          backgroundColor: Colors.grey,
          content: Text(body,
              style: TextStyle(color: Colors.blue),
              overflow: TextOverflow.ellipsis),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    });
  }

  getIosPermissions() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(alert: true, badge: true, sound: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((settings) {
      print("Settings registered sucesfully + $settings");
    });
  }

  saveUserInfoToFireStore() async {
    final GoogleSignInAccount gcurrentUser = gSignIn.currentUser;
    DocumentSnapshot documentSnapshot =
        await usersReference.document(gcurrentUser.id).get();
    if (!documentSnapshot.exists) {
      final username =
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return CreateAccountPage();
      }));
      usersReference.document(gcurrentUser.id).setData({
        'id': gcurrentUser.id,
        'profileName': gcurrentUser.displayName,
        'username': username,
        'url': gcurrentUser.photoUrl,
        'email': gcurrentUser.email,
        'bio': "",
        'timestamp': timestamp
      });
      await followersReference
          .document(gcurrentUser.id)
          .collection("userfollowers")
          .document(gcurrentUser.id)
          .setData({});
      documentSnapshot = await usersReference.document(gcurrentUser.id).get();
    }
    currentUser = User.fromDocument(documentSnapshot);
  }

  //@override
  void dispose() {
    pagecontroller.dispose();
    super.dispose();
  }

  loginUser() {
    gSignIn.signIn();
  }

  logoutUser() {
    gSignIn.signOut();
  }

  whenPagechanges(int pageIndex) {
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }

  Scaffold buildHomeScreen() {
    // key:_scaffoldKey,
    //return Text('alredy signed in');
    /* return //gSignIn.currentUser;
        RaisedButton.icon(
            onPressed: logoutUser,
            icon: Icon(Icons.close),
            label: Text('sign out'));*/
    return Scaffold(
      extendBody: true,
      //extendBodyBehindAppBar: true,
      key: _scaffoldKey,
      // drawer: MainDrawer(),
      /* floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        foregroundColor: Colors.black,
        onPressed: () {
          logoutUser();
        },r
        child: Icon(Icons.close),
      ),*/
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "CookHub",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                //   fontFamily: 'Overpass'),
              ),
            ),
            Text("Recipes",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                  // fontFamily: 'Overpass'),
                )),
          ],
        ),

        //title: Text('CookHub' + 'Recipes'),
        //centerTitle: true,
      ),
      /*PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: AppBar(
          backgroundColor: Colors.blueGrey[900],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50))),
          brightness: Brightness.light,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
                // bottomRight: Radius.circular(30)),
              ),
              gradient: LinearGradient(
                colors: [Colors.pink, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          elevation: 0,
          title: Text('CookHub'),
        ),
      ),*/

      drawer: MainDrawer(),

      body: Column(
        children: [
          Expanded(
            child: PageView(
              children: <Widget>[
                DesignedHome(),

                // ViewImages(),
                SearchPage(),
                UploadPhotoPage(currentUser),
                // globalKey: _scaffoldKey,

                //NotificationsPage(),
                //ProfilePage(userProfileId: currentUser.id),
                Home(),
                //QuestionPage(gCurrentUser: currentUser),
                TimeLinePage(gCurrentUser: currentUser),
              ],
              controller: pagecontroller,
              onPageChanged: whenPagechanges,
              physics: NeverScrollableScrollPhysics(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: getPageIndex,
        onTap: onTapPageChange,
        backgroundColor: Colors.blueGrey[900],
        activeColor: Colors.white,
        inactiveColor: Colors.black,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.add)),
          //BottomNavigationBarItem(icon: Icon(Icons.ring_volume)),
          //BottomNavigationBarItem(icon: Icon(Icons.person)),
          BottomNavigationBarItem(icon: Icon(Icons.web)),
          //BottomNavigationBarItem(icon: Icon(Icons.help)),
          BottomNavigationBarItem(
              icon: Icon(Icons.home_repair_service_outlined))
        ],
      ),
    );
  }

  Scaffold buildSignedScreen() {
    return Scaffold(
      body: Center(
        child: Card(
          color: Colors.grey,
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 35.0),
                  /* Container(
                    height: 400,
                    child: Image(
                      image: AssetImage("images/input.PNG"),
                      fit: BoxFit.contain,
                    ),
                  ),*/
                  SizedBox(height: 20),
                  RichText(
                      text: TextSpan(
                          text: 'Welcome to ',
                          style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Signatra",
                              color: Colors.black),
                          children: <TextSpan>[
                        TextSpan(
                          text: ' cookHub',
                          style: TextStyle(
                            fontSize: 50.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink,
                            fontFamily: "Signatra",
                          ),
                        ),
                      ])),
                  SizedBox(height: 10.0),
                  Text(
                    'Be your own chef',
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 30.0),
                  SizedBox(height: 20.0),
                  SignInButton(
                    Buttons.Google,
                    text: "Sign up with Google",
                    onPressed: () {
                      loginUser();
                    },
                    //color:Colors.pink,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isSignedin == true) {
      return buildHomeScreen();
    } else {
      return buildSignedScreen();
    }
    //  return BuildHomeScreen();
  }
}

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Center(
                child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(currentUser.url), fit: BoxFit.fill),
                  ),
                ),
                Text(currentUser.profileName, style: TextStyle(fontSize: 20)),
                Text(currentUser.email,
                    style: TextStyle(fontFamily: 'signatra', fontSize: 25))
              ],
            ))),
        ListTile(
          leading: Icon(Icons.person),
          title: Text("Profile"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ProfilePage(
                userProfileId: currentUser.id,
              );
            }));
          },
        ),
        Container(
            child: Divider(
              height: 1,
            ),
            color: Colors.grey),
        ListTile(
          leading: Icon(Icons.notifications),
          title: Text("notifications"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return NotificationsPage();
            }));
          },
        ),
        Container(
            child: Divider(
              height: 1,
            ),
            color: Colors.grey),
        ListTile(
          leading: Icon(Icons.person),
          title: Text("My saved recipes"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Saver(
                userProfileId: currentUser.id,
              );
            }));
          },
        ),
        Container(
            child: Divider(
              height: 1,
            ),
            color: Colors.grey),
        ListTile(
          leading: Icon(Icons.group),
          title: Text("cookHub"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return QuestionPage(
                gCurrentUser: currentUser,
              );
            }));
          },
        ),
        Container(
            child: Divider(
              height: 1,
            ),
            color: Colors.grey),
        ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop ingridients"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HomPage();
              }));
            }),
        Container(
            child: Divider(
              height: 1,
            ),
            color: Colors.grey),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text("Logout"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SignOut();
            }));
          },
        ),
        Container(
            child: Divider(
              height: 1,
            ),
            color: Colors.grey)
      ],
    ));
  }
}
