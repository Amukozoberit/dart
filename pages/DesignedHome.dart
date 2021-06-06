import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:newApp/pages/HomePage.dart';
import 'package:newApp/pages/PostScreenPage.dart';
import 'package:newApp/pages/TimeLinePage.dart';
import 'package:newApp/widgets/PostTileWidget.dart';

import 'package:newApp/widgets/PostWidget.dart';
import 'package:newApp/widgets/ProgressWidget.dart';

class DesignedHome extends StatefulWidget {
  @override
  _DesignedHomeState createState() => _DesignedHomeState();
}

class _DesignedHomeState extends State<DesignedHome> {
  List<Post> post;
  bool loading = false;
  int CountPost = 0;
  List<Post> postList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllProfilePosts();
  }

  getAllProfilePosts() async {
    setState(() {
      loading = true;
    });
    QuerySnapshot querysnapShot = await postsReference //postsReference
        .document(currentUser.id)
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
      return StaggeredGridView.countBuilder(
        scrollDirection: Axis.horizontal,
        crossAxisCount: 2,
        itemCount: gridTilesList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              //color: Colors.grey,
              width: ScreenUtil().setWidth(450),
              margin: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 20),
              height: ScreenUtil().setHeight(550),
              decoration: BoxDecoration(
                  color: Colors.orange.shade400,
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: FittedBox(fit: BoxFit.cover, child: gridTilesList[index]));
        },
        staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(1125, 2436), allowFontScaling: true);
    return Scaffold(
      //backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*  Padding(
              padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(80),
                  left: ScreenUtil().setWidth(50),
                  right: ScreenUtil().setWidth(50)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('     '),
                    ClipOval(
                        clipper: MyClip(),
                        child: Image.network(
                          // "assets/images/hert.webp",
                          currentUser.url,
                          width: ScreenUtil().setWidth(160),
                          height: ScreenUtil().setHeight(160),
                          fit: BoxFit.cover,
                        )),
                  ])),*/
          Padding(
            padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(70),
                left: ScreenUtil().setWidth(70),
                right: ScreenUtil().setWidth(105)),
            child: Text("Choose the food you love",
                style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'signatra',
                    fontSize: 30)),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(70),
                right: ScreenUtil().setWidth(70)),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'search by recipe name',
                hintStyle: TextStyle(color: Colors.black38),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(60),
                left: ScreenUtil().setWidth(70),
                right: ScreenUtil().setWidth(105)),
            child: Text("Categories",
                style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'signatra',
                    fontSize: 30)),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(70),
          ),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                child: Card(
                    margin: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(20),
                      horizontal: ScreenUtil().setWidth(20),
                    ),
                    child: FittedBox(
                        fit: BoxFit.fill,
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          children: [
                            Container(
                              width: ScreenUtil().setWidth(450),
                              margin: EdgeInsets.only(
                                  right: 20, left: 20, top: 20, bottom: 20),
                              height: ScreenUtil().setHeight(550),
                              decoration: BoxDecoration(
                                  color: Colors.orange.shade400,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Web\nRecipes",
                                      style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    IconButton(
                                        icon:
                                            Icon(Icons.http_rounded, size: 50),
                                        onPressed: null)
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: ScreenUtil().setWidth(450),
                              margin: EdgeInsets.only(
                                  right: 20, left: 20, top: 20, bottom: 20),
                              height: ScreenUtil().setHeight(550),
                              decoration: BoxDecoration(
                                  color: Colors.orange.shade400,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "All\nRecipes",
                                      style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.collections, size: 50),
                                        onPressed: null)
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: ScreenUtil().setWidth(450),
                              margin: EdgeInsets.only(
                                  right: 20, left: 20, top: 20, bottom: 20),
                              height: ScreenUtil().setHeight(550),
                              decoration: BoxDecoration(
                                  color: Colors.orange.shade400,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Shop\nRecipes\nIngridients",
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      IconButton(
                                          icon:
                                              Icon(Icons.add_a_photo, size: 50),
                                          onPressed: null)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ))),
              )),
          SizedBox(
            height: ScreenUtil().setHeight(70),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(60),
                left: ScreenUtil().setWidth(70),
                right: ScreenUtil().setWidth(105)),
            child: Text("Explore our recipes",
                style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'signatra',
                    fontSize: 30)),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(900),
            child: displayProfilePost(),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(900),
            child: Align(
              alignment: Alignment.center,
              child: Text('Be your own chef ',
                  style: TextStyle(
                    fontFamily: 'Signatra',
                    color: Colors.orange,
                    fontSize: 50,
                  )),
            ),
          ),
        ],
      )),
    );
  }
}
