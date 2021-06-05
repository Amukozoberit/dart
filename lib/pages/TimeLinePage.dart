import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:newApp/pages/HomePage.dart';
import 'package:newApp/pages/PostScreenPage.dart';
import 'package:newApp/pages/recipeSearch.dart';

import 'package:newApp/stopwatch/timing.dart';
import 'package:newApp/webrecipes/Homes.dart';
import 'package:newApp/widgets/PostTileWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newApp/models/user.dart';
import 'package:newApp/widgets/HeaderWidget.dart';
//import 'package:newApp/widgets/PostTileWidget.dart';
import 'package:newApp/widgets/PostWidget.dart';
import 'package:newApp/widgets/ProgressWidget.dart';
//import 'package:newApp/webrecipes/Homes.dart';
//import 'User'
//import 'user.dart';

class TimeLinePage extends StatefulWidget {
  final User gCurrentUser;

  const TimeLinePage({Key key, this.gCurrentUser}) : super(key: key);

  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  List<Post> posts;
  List<String> followingsList = [];
  String name = '';

  //List<Post> postList = [];
  //bool loading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveTimeLine();
    retrieveFollowings();
  }

  retrieveTimeLine() async {
    QuerySnapshot querySnapshot = await timelineReference
        .document(widget.gCurrentUser.id)
        .collection('timelinePosts')
        .orderBy("timestamp", descending: true)
        .getDocuments();

    List<Post> allPosts = querySnapshot.documents.map((doc) {
      //return Post.fromDocument(doc);
      //  print(doc['url']);
      return Post(
        postId: doc['postId'],
        ownerId: doc['ownerId'],
        //  timestamp: documentSnapshot['timestamp'],
        likes: doc['likes'],
        username: doc['username'],
        description: doc['description'],
        url: doc['url'],
      );
    }).toList();
    print(allPosts);
    if (this.mounted) {
      setState(() {
        this.posts = allPosts;
      });
    }
    print(posts);
    return posts;

//    print(posts.);
  }

  retrieveSearchTimeLine() async {
    QuerySnapshot querySnapshot = await timelineReference
        .document(widget.gCurrentUser.id)
        .collection('timelinePosts')
        .where('searchKey', arrayContains: name)
        .orderBy("timestamp", descending: true)
        .getDocuments();

    List<Post> allPosts = querySnapshot.documents.map((doc) {
      //return Post.fromDocument(doc);
      //  print(doc['url']);
      return Post(
        postId: doc['postId'],
        ownerId: doc['ownerId'],
        //  timestamp: documentSnapshot['timestamp'],
        likes: doc['likes'],
        username: doc['username'],
        description: doc['description'],
        url: doc['url'],
      );
    }).toList();
    print(allPosts);
    if (this.mounted) {
      setState(() {
        this.posts = allPosts;
      });
    }
    print(posts);
    return posts;

//    print(posts.);
  }

  retrieveFollowings() async {
    QuerySnapshot querySnapshot = await followingReference
        .document(currentUser.id)
        .collection("userfollowing")
        .getDocuments();
    if (this.mounted) {
      setState(() {
        followingsList = querySnapshot.documents.map((document) {
          document.documentID;
        }).toList();
      });
    }
  }

  createUserTimeLine() {
    if (posts == null) {
      return circularProgress();
    } else {
      List<GridTile> gridTilesList = [];
      posts.forEach((eachPost) {
        //  gridTilesList.
        // print(eachPost);
        gridTilesList.add(GridTile(child: PostTile(post: eachPost)));
        print(eachPost);
      });
      return StaggeredGridView.countBuilder(
        //     scrollDirection: Axis.vertical,
        crossAxisCount: 4,
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              //color: Colors.grey,

              decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: FittedBox(
                  fit: BoxFit.cover,
                  child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return PostScreenPage(
                            userId: posts[index].ownerId,
                            postId: posts[index].postId,
                            url: posts[index].url,
                          );
                        }));
                      },
                      child: posts[index])));
        },
        staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      );
    }
  }
  /* List<Post> gridTilesList = [];
      setState(() {
        gridTilesList = posts;
      });

      return Expanded(
              child: GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          mainAxisSpacing: 1.5,
          crossAxisSpacing: 1.5,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: gridTilesList,
        ),
      );
    }*/
  //  gridTilesList.
  // print(eachPost);
  //posts.add(GridTile(child: PostTile(post: eachPost)));
  //gridTilesList.add(Post(children:[PostTile(post:eachPost));
  //print(eachPost);
  //});/*

  /* return StaggeredGridView.countBuilder(
        scrollDirection: Axis.vertical,
        crossAxisCount: 4,
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return PostScreenPage(
                  userId: posts[index].ownerId,
                  postId: posts[index].postId,
                  url: posts[index].url,
                );
              }));
            },
         child Container(
              //color: Colors.grey,
              width: ScreenUtil().setWidth(450),
              margin: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 20),
              height: ScreenUtil().setHeight(550),
              decoration: BoxDecoration(
                  color: Colors.orange.shade400,
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: FittedBox(fit: BoxFit.cover, child: posts[index]));
          );
        },
        staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      );
    }*/

  @override
  Widget build(context) {
    return Scaffold(
        key: scaffoldKey,

        //header(
        //context,
        //isAppTitle: true,
        //),
        body: Column(
          children: [
            SizedBox(
              height: 70,
              child: Container(
                padding: EdgeInsets.only(left: 5),
                child: ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return Search();
                    }));
                  },
                  title: TextField(
                    onChanged: (val) {
                      name = val;
                    },
                    decoration: InputDecoration(
                        hintText: "Choose the food you love",
                        hintStyle: TextStyle(
                            color: Colors.black87,
                            fontFamily: 'signatra',
                            fontSize: 30)),
                  ),
                  trailing: Icon(Icons.search),
                ),
              ),
            ),
            
            Expanded(
                child: RefreshIndicator(
              child: createUserTimeLine(),
              onRefresh: () => retrieveTimeLine(),
            )),
          ],
        ));
  }
  Future<QuerySnapshot> futureSearchResults;
  logoutUser() {
    gSignIn.signOut();
  }
}
