import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newApp/models/user.dart';
import 'package:newApp/pages/HomePage.dart';
import 'package:newApp/pages/fullQuestionView.dart';
import 'package:newApp/widgets/ProgressWidget.dart';
import "package:timeago/timeago.dart" as tAgo;

import 'StructureQuiz.dart';

class QuestionPage extends StatefulWidget {
  final User gCurrentUser;

  const QuestionPage({Key key, this.gCurrentUser}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final _globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _globalKey,
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: Text('Questions'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: displayquestions(),
            ),
            Divider(),
            Align(
              alignment: Alignment.bottomLeft,
              child: ListTile(
                title: RaisedButton(
                  onPressed: () {
                    nav();
                  },
                  color: Colors.white,
                  textColor: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('ask your question'),
                      Icon(
                        Icons.add,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Divider(height: 10),
          ],
        ));
  }

  displayquestions() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Questions')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        }
        List<Question> questions = [];
        dataSnapshot.data.documents.forEach((document) {
          questions.add(Question.fromDocument(document));
        });
        return ListView(
          children: questions,
        );
      },
    );
  }

  void nav() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StructuredQuiz(globalKey: _globalKey)));
  }
}

class Question extends StatelessWidget {
  final String username;
  final String userId;
  //final String url;
  final String postId;
  final Timestamp timestamp;
  final String questionOwner;
  final String questionBody;
  final String questionTitle;

  const Question(
      {Key key,
      this.username,
      this.userId,
      // this.url,
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
      //url: document['url'],
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
      padding: EdgeInsets.only(bottom: 6.0),
      child: Container(
          // decoration: DecoratedBox(decoration: background,),
          //backgroundColor: Colors.white,
          color: Colors.white70,
          child: Column(
            children: [
              ListTile(
                title: Text(username + ":" + questionTitle,
                    style: TextStyle(fontSize: 18, color: Colors.black)),
                subtitle: Text(
                  tAgo.format(timestamp.toDate()),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                trailing: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullQuestionView(
                                    questionId: postId,
                                  )));
                    },
                    child: Text('Read more',
                        style: TextStyle(color: Colors.blueGrey))),
              )
            ],
          )),
    );
  }
}
