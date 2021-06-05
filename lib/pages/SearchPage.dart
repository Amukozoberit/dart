import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newApp/models/user.dart';
import 'package:newApp/pages/ProfilePage.dart';
import 'package:newApp/widgets/ProgressWidget.dart';
import 'HomePage.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin<SearchPage> {
  TextEditingController searchTextEditingController = TextEditingController();
  Future<QuerySnapshot> futureSearchResults;
  controlSearching(String str) {
    Future<QuerySnapshot> allUsers = usersReference
        .where("profileName", isGreaterThanOrEqualTo: str)
        .getDocuments();
    setState(() {
      futureSearchResults = allUsers;
    });
    //usersReference.where("profileName",
    //    isGreatorThanOrEqualTo: str.getDocuments);
  }

  emptyTextFormField() {
    searchTextEditingController.clear();
  }

  AppBar searchPageHeader() {
    return AppBar(
      backgroundColor: Colors.black,
      title: TextFormField(
        style: TextStyle(fontSize: 18.0, color: Colors.white),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          border: OutlineInputBorder(),
          labelText: 'search here',
          labelStyle: TextStyle(fontSize: 15.0),
          //hintText: '',
          hintStyle: TextStyle(color: Colors.grey),
          filled: true,
          prefixIcon: Icon(Icons.person_pin, color: Colors.white, size: 30.0),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: emptyTextFormField(),
          ),
        ),
        onFieldSubmitted: controlSearching,
      ),
    );
  }

  Container displaySearchResultsScreen() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
        child: Center(
            child: ListView(
      shrinkWrap: true,
      children: [
        Icon(Icons.group, color: Colors.grey, size: 200.0),
        Text(
          "Search users",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 65.0),
        ),
      ],
    )));
  }

  displayUserFoundScreen() {
    return FutureBuilder(
        future: futureSearchResults,
        builder: (context, datasnapshot) {
          if (!datasnapshot.hasData) {
            return circularProgress();
          }
          List<UserResult> searchUsersResults = [];
          datasnapshot.data.documents.forEach((document) {
            User eachusers = User.fromDocument(document);
            UserResult userResult = UserResult(eachusers);
            searchUsersResults.add(userResult);
          });
          return ListView(
            children: searchUsersResults,
            //  searchUse
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // return Text('Search Page goes here.');
    return Scaffold(
      // backgroundColor: Color.,
      appBar: searchPageHeader(),
      body: futureSearchResults == null
          ? displaySearchResultsScreen()
          : displayUserFoundScreen(),
    );
  }

// @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true; //throw UnimplementedError();
}

class UserResult extends StatelessWidget {
  final User eachUser;

  const UserResult(this.eachUser);
  displayUserProfile(BuildContext context, String userProfileId) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProfilePage(
        userProfileId: userProfileId,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    //return Text("User Result here.");
    return Padding(
        padding: EdgeInsets.all(3.0),
        child: Container(
            color: Colors.white,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // print('tap');
                    displayUserProfile(context, eachUser.id);
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        backgroundImage:
                            CachedNetworkImageProvider(eachUser.url)),
                    title: Text(
                      eachUser.profileName,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      eachUser.username,
                      style: TextStyle(color: Colors.black, fontSize: 23.0),
                    ),
                  ),
                ),
              ],
            )));
  }
}
