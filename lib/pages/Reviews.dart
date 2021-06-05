import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'HomePage.dart';

class Reviewers extends StatefulWidget {
  final String postId;
  final String postOwnerId;

  const Reviewers({
    Key key,
    this.postId,
    this.postOwnerId,
  }) : super(key: key);
  @override
  _ReviewersState createState() => _ReviewersState();
}

class _ReviewersState extends State<Reviewers> {
  TextEditingController reviewTextEditingController = TextEditingController();
  Widget rev() {
    return RatingBar.builder(
      initialRating: 3,
      itemCount: 5,
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return Icon(
              Icons.sentiment_very_dissatisfied,
              color: Colors.black26,
            );
          case 1:
            return Icon(
              Icons.sentiment_dissatisfied,
              color: Colors.black38,
            );
          case 2:
            return Icon(
              Icons.sentiment_neutral,
              color: Colors.black45,
            );
          case 3:
            return Icon(
              Icons.sentiment_satisfied,
              color: Colors.black54,
            );
          case 4:
            return Icon(
              Icons.sentiment_very_satisfied,
              color: Colors.black87,
            );
        }
      },
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text('Question site'), backgroundColor: Colors.pink),
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Center(
              child: Card(
                child: Container(
                  height: 410,
                  width: 410,
                  color: Colors.grey,
                  margin: EdgeInsets.all(50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          child: Text('Reviews',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold))),
                      // Container(child: Text('Reviewers:')),
                      rev(),
                      Divider(),
                      TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: TextStyle(color: Colors.black),
                        controller: reviewTextEditingController,
                        decoration: InputDecoration(
                            hintText: 'tell us why',
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.pink, width: 5.0),
                            )),
                      ),
                      Divider(height: 200),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: RaisedButton(
                          onPressed: null,
                          /* SnackBar snackbar = SnackBar(
                                content: Text('Please wait, we are uploading'));
                            widget.globalKey.currentState.showSnackBar(snackbar);
                            */

                          color: Colors.red,
                          textColor: Colors.white,
                          child: GestureDetector(
                            onTap: () {
                              saveComment();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('publish review'),
                                Icon(Icons.publish_outlined),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  saveComment() {
    reviewsReference.document(currentUser.id).collection('reviews').add({
      "username": currentUser.username,
      "review": reviewTextEditingController.text,
      "timestamp": DateTime.now(),
      "url": currentUser.url,
      "id": currentUser.id
    });

    // _commenttexteditingController.clear();
    reviewTextEditingController.clear();

    bool isNotPostOwner = widget.postOwnerId != currentUser.id;
    if (isNotPostOwner) {
      reviewsReference
          .document(widget.postOwnerId)
          .collection('reviewItems')
          .add({
        "type": "review",
        "commentData": reviewTextEditingController.text,
        "postid": widget.postId,
        "userId": currentUser.id,
        "username": currentUser.username,
        "userProfileImg": currentUser.url,
        "timestamp": DateTime.now(),
      });
    }
   
    // _commenttexteditingController.clear();
    reviewTextEditingController.clear();
    Navigator.pop(context);
  }
}
