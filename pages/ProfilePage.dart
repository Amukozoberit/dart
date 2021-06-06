import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newApp/models/user.dart';
import 'package:newApp/pages/EditProfilePage.dart';
import 'package:newApp/widgets/PostTileWidget.dart';
import 'package:newApp/widgets/PostWidget.dart';

import 'HomePage.dart';
import 'package:flutter/material.dart';
import 'package:newApp/pages/HomePage.dart';
import 'package:newApp/widgets/HeaderWidget.dart';
import 'package:newApp/widgets/ProgressWidget.dart';

class ProfilePage extends StatefulWidget {
  final String userProfileId;

  const ProfilePage({Key key, this.userProfileId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String currentOnlineUserId = currentUser.id;
  bool loading = false;
  int CountPost = 0;
  String posTorientation = "grid";
  List<Post> postList = [];
  int countTotalFollowers = 0;
  int countTotalFollowings = 0;
  bool following = false;
  @override
  void initState() {
    super.initState();
    getAllProfilePosts();
    getAllfollowers();
    getAllfollowings();
    chekifAlredyfollowing();
  }

  chekifAlredyfollowing() async {
    DocumentSnapshot documentSnapshot = await followersReference
        .document(widget.userProfileId)
        .collection("userfollowers")
        .document(currentOnlineUserId)
        .get();
    setState(() {
      following = documentSnapshot.exists;
    });
  }

  getAllfollowings() async {
    QuerySnapshot querySnapshot = await followingReference
        .document(widget.userProfileId)
        .collection("userfollowing")
        .getDocuments();
    if (mounted) {
      setState(() {
        countTotalFollowings = querySnapshot.documents.length;
      });
    }
  }

  getAllfollowers() async {
    QuerySnapshot querySnapshot = await followersReference
        .document(widget.userProfileId)
        .collection("userfollowers")
        .getDocuments();
    setState(() {
      countTotalFollowers = querySnapshot.documents.length;
    });
  }

  createProfileTopView() {
    return FutureBuilder(
      future: usersReference.document(widget.userProfileId).get(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();

          /// print('error');
        }

        User user = User.fromDocument(dataSnapshot.data);
        // bool isPostOwner = currentOnlineUserId == ownerId;
        return Padding(
          padding: EdgeInsets.all(17),
          child: Column(
            children: [
              Row(children: [
                CircleAvatar(
                  radius: 45.0,
                  backgroundColor: Colors.grey,
                  backgroundImage: CachedNetworkImageProvider(user.url),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        //mainAxisSize: mainAxisSize.max,
                        children: [
                          createColumns("posts", CountPost),
                          createColumns("followers", countTotalFollowers),
                          createColumns("following", countTotalFollowings),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          createButton(),
                        ],
                      )
                    ],
                  ),
                ),
              ]),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 13.0),
                child: Text(
                  //'mwashe',
                  user.username,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 13.0),
                child: Text(
                  user.profileName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 13.0),
                child: Text(
                  user.bio,
                  //'user',
                  //   if(user.bio ==null){

                  //'user',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Column createColumns(String title, int count) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(count.toString(),
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          Container(
              margin: EdgeInsets.only(top: 5.0),
              child: Text(title,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold))),
        ]);
  }

  createButton() {
    bool onProfile = currentOnlineUserId == widget.userProfileId;
    if (onProfile) {
      return createButtonTitleAndFunction(
          title: "editprofile", perfomFunction: editUserProfile);
    } else if (following) {
      return createButtonTitleAndFunction(
          title: "unfollow", perfomFunction: controlUnfollowUser);
    } else if (!following) {
      return createButtonTitleAndFunction(
          title: "follow", perfomFunction: controlfollowUser);
    }
  }

  controlUnfollowUser() {
    setState(() {
      following = false;
    });
    followersReference
        .document(widget.userProfileId)
        .collection("userfollowers")
        .document(currentOnlineUserId)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });

    followingReference
        .document(currentOnlineUserId)
        .collection("userfollowing")
        .document(currentOnlineUserId)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
    activityFeedReference
        .document(widget.userProfileId)
        .collection('feedItems')
        .document(currentOnlineUserId)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
  }

  controlfollowUser() {
    setState(() {
      following = true;
    });
    followersReference
        .document(widget.userProfileId)
        .collection("userfollowers")
        .document(currentOnlineUserId)
        .setData({});
    followingReference
        .document(currentOnlineUserId)
        .collection("userfollowing")
        .document(widget.userProfileId)
        .setData({});
    activityFeedReference
        .document(widget.userProfileId)
        .collection('feedItems')
        .document(currentOnlineUserId)
        .setData({
      "type": "follow",
      "ownerId": widget.userProfileId,
      "username": currentUser.username,
      "timestamp": DateTime.now(),
      "userProfileImg": currentUser.url,
      "userId": currentOnlineUserId,
    });
  }

  createButtonTitleAndFunction({String title, Function perfomFunction}) {
    return Container(
        padding: EdgeInsets.only(top: 3.0),
        child: FlatButton(
            onPressed: perfomFunction,
            child: Container(
                width: 245.0,
                height: 26.0,
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: following ? Colors.grey : Colors.pink,
                      fontWeight: FontWeight.bold),
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: following ? Colors.pink : Colors.blue,
                  border:
                      Border.all(color: following ? Colors.grey : Colors.grey),
                  borderRadius: BorderRadius.circular(6.0),
                ))));
  }

  editUserProfile() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditProfilePage(currentOnlineUserId: currentOnlineUserId);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
        context,
        strTitle: 'Profile',
      ),
      body: ListView(children: [
        createProfileTopView(),
        Divider(),
        createListAndGridPostPresentation(),
        Divider(
          height: 0.0,
        ),
        displayProfilePost(),
      ]),
    );
  }

  createListAndGridPostPresentation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: setOrientation('grid'),
          icon: Icon(Icons.grid_on),
          color: posTorientation == "grid"
              ? Theme.of(context).primaryColor
              : Colors.grey,
        ),
        IconButton(
          onPressed: setOrientation('list'),
          icon: Icon(Icons.list),
          color: posTorientation == "list"
              ? Theme.of(context).primaryColor
              : Colors.grey,
        )
      ],
    );
  }

  setOrientation(String orientation) {
    setState(() {
      this.posTorientation = orientation;
    });
  }

  displayProfilePost() {
    if (loading) {
      return circularProgress();
    } else if (postList.isEmpty) {
      return Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Icon(Icons.photo_library, color: Colors.grey, size: 200.0),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            // child: Icon(Icons.photo_library, color: Colors.grey,
            // size: 200.0),
            child: Text(
              'no post',
              style: TextStyle(
                  fontSize: 40.0,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ));
    } else if (postList.isNotEmpty) {
      //else if (posTorientation == "grid") {
      List<GridTile> gridTilesList = [];
      postList.forEach((eachPost) {
        //  gridTilesList.
        // print(eachPost);
        gridTilesList.add(GridTile(child: PostTile(post: eachPost)));
       print(eachPost);
      });
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTilesList,
      );
    }
  }

  getAllProfilePosts() async {
    setState(() {
      loading = true;
    });
    QuerySnapshot querysnapShot = await postsReference //postsReference
        .document(widget.userProfileId)
        .collection("userPosts")
        .orderBy("timestamp", descending: true)
        .getDocuments();
    print(querysnapShot.documents.map((doc) {
      //doc.documentID
      print('doc');
      print(doc['postId']);
      print(doc['description']);
      print(doc['url']);
      // url:doc['url'],
    }));

    setState(() {
      loading = false;
      CountPost = querysnapShot.documents.length;
      print(CountPost); //documents.length;
      postList = querysnapShot.documents.map((documentSnapshot) {
        return Post.fromDocument(documentSnapshot);

        // print(doc.)
        //Post.fromDocument(documentSnapshot);
        // documentSnapshot.data['url'],
        //  return postList(doc[]);

        //print(Post);
      }).toList();
      //print(postList.description);
      //  return postList;
    });
    //print(postList);
  }
}
