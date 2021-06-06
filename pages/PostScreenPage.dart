import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newApp/pages/Saver.dart';
import 'package:newApp/pages/reveiwDesign.dart';
import 'package:newApp/pages/shareRecipe.dart';
//import 'package:newApp/chats/chart.dart';
//import 'package:newApp/chats/chatpage.dart';
//import 'package:newApp/chats/login.dart';
import 'package:newApp/widgets/HeaderWidget.dart';
import 'package:newApp/widgets/PostWidget.dart';
import 'package:newApp/widgets/ProgressWidget.dart';
import 'package:share/share.dart';
import 'HomePage.dart';
import 'Reviews.dart';
import "package:timeago/timeago.dart" as tAgo;

class PostScreenPage extends StatefulWidget {
  final String userId;
  final String postId;
  // final Post post;
  final url;
  const PostScreenPage({Key key, this.userId, this.postId, this.url})
      : super(key: key);

  @override
  _PostScreenPageState createState() => _PostScreenPageState();
}

class _PostScreenPageState extends State<PostScreenPage> {
  double rates;
  TextEditingController descTextEdititngController = TextEditingController();
  int CountPost = 0;
  List<ReviewDesign> postList = [];
  bool loading = false;

  share(BuildContext context, Post post) {
    final RenderBox box = context.findRenderObject();
    final String text = "${post.url}-${post.description}";
    Share.share(text,
        subject: post.url,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  save(String postid, String ownerid, dynamic likes, String username,
      String description, String url) {
    //FirebaseUser htu=User.id;

    savedToStore
        .document(
          currentUser.id,
        )
        .collection('savedPosts')
        .document(widget.postId)
        .setData({
      'postId': widget.postId,
      'ownerId': currentUser.id,
      'timestamp': DateTime.now(),
      "likes": likes,
      "username": username,
      "description": description,
      "url": url,
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Saver(
        userProfileId: ownerid,
      );
    }));
  }

  Widget rats() {
    return Container(
        color: Colors.white,
        child: RatingBar.builder(
          initialRating: 0,
          minRating: 3,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.pink,
          ),
          onRatingUpdate: (rating) {
            print(rating);
            setState(() {
              rates = rating;
            });
            //Expanded(child: TextFormField());
            //},
          },
        ));
  }

  @override
  void initState() {
    super.initState();
    getReviews();
  }

  getReviews() async {
    QuerySnapshot querysnapShot = await reviewsReference //postsReference
        .document(widget.userId)
        .collection("reviews")
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
        return ReviewDesign.fromDocument(documentSnapshot);

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

      return ListView(
        children: postList,
        shrinkWrap: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //final items=List<String>
    // List<String> items = [];
    //String rates;

    return FutureBuilder(
        future: postsReference
            .document(widget.userId)
            .collection('userPosts')
            .document(widget.postId)
            .get(),
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return circularProgress();
          else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              Post post = Post.fromDocument(snapshot.data);
              String newlist = post.buyList;
              return Scaffold(
                body: Padding(
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20)),
                  child: Container(
                    height: double.infinity,
                    child: ListView(
                      children: <Widget>[
                        SizedBox(height: 40.0),
                        Text(
                          post.description.toUpperCase() +
                              "\n" +
                              " by " +
                              post.username,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 30.0),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          "In a small bowl, combine,\ncinnamon, nutmeg and sugar and \nset aside briefly.",
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: 50.0),
                        SizedBox(
                          height: 30.0,
                          width: double.infinity,
                          child: Row(
                            children: <Widget>[
                              Icon(FontAwesomeIcons.fire, color: Colors.white),
                              SizedBox(width: 5.0),
                              Text(
                                "65%",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0),
                              ),
                              Spacer(),
                              VerticalDivider(color: Colors.white),
                              Icon(FontAwesomeIcons.server,
                                  color: Colors.white),
                              SizedBox(width: 5.0),
                              Text(
                                post.serve,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0),
                              ),
                              Spacer(),
                              VerticalDivider(color: Colors.white),
                              Icon(FontAwesomeIcons.stopwatch,
                                  color: Colors.white),
                              SizedBox(width: 5.0),
                              Text(
                                post.prep,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Container(
                          height: 380,
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(color: Colors.black38, blurRadius: 30.0)
                          ]),
                          child: Stack(
                            children: [
                              Positioned(
                                // top:30,
                                height: 350,
                                width: ScreenUtil().screenWidth,
                                child: FittedBox(
                                  child: Image.network(post.url),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 325,
                                left: 0,
                                child: CircleAvatar(
                                    child: InkWell(
                                        onTap: () {
                                          share(context, post);
                                        },
                                        child: Icon(Icons.share,
                                            color: Colors.red))),
                              ),
                              Positioned(
                                top: 325,
                                left: ScreenUtil().screenWidth * 0.5,
                                child: CircleAvatar(
                                    child: InkWell(
                                        onTap: () {
                                          save(
                                              post.postId,
                                              post.ownerId,
                                              post.likes,
                                              post.username,
                                              post.description,
                                              post.url);
                                        },
                                        child: Icon(Icons.save,
                                            color: Colors.red))),
                              ),
                              Positioned(
                                top: 325,
                                right: 0,
                                child: CircleAvatar(
                                    child: InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return Reviewers(
                                          postId: post.postId,
                                          postOwnerId: post.ownerId);
                                    }));
                                  },
                                  child: Icon(Icons.rate_review,
                                      color: Colors.red),
                                )),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "Ingridients",
                          style: TextStyle(color: Colors.white70, fontSize: 20),
                        ),
                        Text(
                          post.ing,
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          "Steps",
                          style: TextStyle(color: Colors.white70, fontSize: 20),
                        ),
                        Text(
                          post.steps,
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        Container(
                            height: 70.0,
                            child: AppBar(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            )),
                        Text('Reviews', style: TextStyle(fontSize: 30)),
                        displayProfilePost(),
                        FlatButton.icon(
                          color: Colors.red,
                          icon: Icon(Icons.shop),
                          onPressed: () {
                            ListView(
                              children: newlist
                                  .split(',') // split the text into an array
                                  .map((String text) {
                                print(text);
                                print('a');
                              }) // put the text inside a widget
                                  .toList(), // convert the iterable to a list
                            );
                          },
                          label: Text('shop ingridients'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
        });
  }
}
