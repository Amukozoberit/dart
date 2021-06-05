import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:newApp/pages/HomePage.dart';
import 'package:newApp/pages/questions.dart';
import 'package:newApp/widgets/ProgressWidget.dart';

import "package:timeago/timeago.dart" as tAgo;

class FullQuestionView extends StatefulWidget {
  final String questionId;

  const FullQuestionView({Key key, this.questionId}) : super(key: key);
  @override
  _FullQuestionViewState createState() => _FullQuestionViewState();
}

class _FullQuestionViewState extends State<FullQuestionView> {
  displayquestions() {
    return FutureBuilder(
        future: questionReference.document(widget.questionId).get(),
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return circularProgress();
          else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              // return snapshot.data['id'];
              Question post = Question.fromDocument(snapshot.data);
              print(snapshot.data['urls'].length);
              List<NetworkImage> _listOfImage = <NetworkImage>[];
              snapshot.data['urls'].forEach((d) {
                // print(snapshot.data['urls'].length);
                _listOfImage.add(NetworkImage(d));
              });
              return Column(
                children: [
                  Container(
                      child: Text(
                    post.questionTitle+' asked  by '+post.username
                  )),
                  Divider(
                    height: 10,
                  ),
                  Container(
                      child: Text(
                    post.questionBody,
                  )),
                   Divider(
                    height: 10,
                  ),
                   Container(
                      child: Text(
                    'what i get versus what i expect',
                  )),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Carousel(
                      boxFit: BoxFit.cover,
                      images: _listOfImage,
                      autoplay: true,
//      animationCurve: Curves.fastOutSlowIn,
//      animationDuration: Duration(milliseconds: 1000),
                      dotSize: 4.0,
                      indicatorBgPadding: 2.0,
                    ),
                  ),
                ],
              );
            }

            // return post;

          }
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: Text('read more')),
        body: ListView(children: [
          displayquestions(),
        ]));
  }
}

class Question extends StatelessWidget {
  final String username;
  final String userId;
  //final url;
  final String postId;
  final Timestamp timestamp;
  final String questionOwner;
  final String questionBody;
  final String questionTitle;

  const Question(
      {Key key,
      this.username,
      this.userId,
      //this.url,
      this.postId,
      this.timestamp,
      this.questionOwner,
      this.questionBody,
      this.questionTitle})
      : super(key: key);
  factory Question.fromDocument(DocumentSnapshot document) {
    return Question(
      username: document['username'],
      userId: document['id'],

      //url: document['urls'],
      postId: document['postId'],
      questionOwner: document['questionOwner'],
      questionBody: document['questionBody'],
      questionTitle: document['questionTitle'],
      timestamp: document["timestamp"],
      //avatarUrl: document["avatarUrl"],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.0, right: 2.0),

      // decoration: DecoratedBox(decoration: background,),
      //backgroundColor: Colors.white,

      child: Column(mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(questionTitle,
                style: TextStyle(fontSize: 18, color: Colors.pink)),
            Text(questionBody,
                style: TextStyle(fontSize: 18, color: Colors.black)),
            Text('what i want versus what i get',
                style: TextStyle(fontSize: 18, color: Colors.pink)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  tAgo.format(timestamp.toDate()),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ]),
    );
  }
}
