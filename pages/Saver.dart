import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:newApp/pages/PostScreenPage.dart';
import 'package:newApp/widgets/HeaderWidget.dart';
import 'package:newApp/widgets/PostTileWidget.dart';
import 'package:newApp/widgets/PostWidget.dart';
import 'package:newApp/widgets/ProgressWidget.dart';

import 'HomePage.dart';

class Saver extends StatefulWidget {
  final userProfileId;

  const Saver({Key key, this.userProfileId}) : super(key: key);

  @override
  _SaverState createState() => _SaverState();
}

class _SaverState extends State<Saver> {
  int CountPost = 0;
  List<Post> postList = [];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    getAllProfilePosts();
  }

  getAllProfilePosts() async {
    QuerySnapshot querysnapShot = await savedToStore //postsReference
        .document(widget.userProfileId)
        .collection("savedPosts")
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
      return GridView.count(
        crossAxisCount: 1,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: postList,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: header(
        context,
        strTitle: 'My saved Recipes',
      ),
      body: ListView(children: [
        displayProfilePost(),
      ]),
    );
  }
}
