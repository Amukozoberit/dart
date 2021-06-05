import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newApp/pages/HomePage.dart';
import 'package:newApp/widgets/ProgressWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:timeago/timeago.dart" as tAgo;

class CommentsPage extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postImageUrl;

  const CommentsPage(
      {Key key, this.postId, this.postOwnerId, this.postImageUrl})
      : super(key: key);
  @override
  CommentsPageState createState() => CommentsPageState(
      postId: postId, postOwnerId: postOwnerId, postImageUrl: postImageUrl);
}

class CommentsPageState extends State<CommentsPage> {
  final String postId;
  final String postOwnerId;
  final String postImageUrl;
  TextEditingController _commenttexteditingController = TextEditingController();

  CommentsPageState({this.postId, this.postOwnerId, this.postImageUrl});
  saveComment() {
    commentsReference.document(postId).collection('comments').add({
      "username": currentUser.username,
      "comment": _commenttexteditingController.text,
      "timestamp": DateTime.now(),
      "url": currentUser.url,
      "id": currentUser.id
    });
    bool isNotPostOwner = postOwnerId != currentUser.id;
    if (isNotPostOwner) {
      commentsReference.document(postOwnerId).collection('feedItems').add({
        "type": "comment",
        "commentData": _commenttexteditingController.text,
        "postid": postId,
        "userId": currentUser.id,
        "username": currentUser.username,
        "userProfileImg": currentUser.url,
        "url": postImageUrl,
        "timestamp": DateTime.now(),
      });
    }
    _commenttexteditingController.clear();
  }

  displayComments() {
    return StreamBuilder(
      stream: commentsReference
          .document(postId)
          .collection('comments')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      /* builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return circularProgress();
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<Comment> comments = [];
              comments = snapshot.data.documents.forEach((document) {
                return Comment.fromDocument(document);
                // comments.add(Comment.from)
              });
              return ListView(
                children: comments,
              );
            } else {
              return Center(child: Text("No data or it's empty"));
            }
          } else {
            return Center(child: Text("No data wait"));
          }
        });*/
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        }
        List<Comment> comments = [];
        dataSnapshot.data.documents.forEach((document) {
          comments.add(Comment.fromDocument(document));
        });
        return ListView(
          children: comments,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // return Text('Here goes Comments Page');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Comments",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: displayComments(),
          ),
          Divider(),
          ListTile(
              title: TextFormField(
                  controller: _commenttexteditingController,
                  decoration: InputDecoration(
                    labelText: 'Write comments here..',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                  style: TextStyle(
                    color: Colors.pink,
                  )),
              trailing: OutlineButton(
                  onPressed: saveComment,
                  borderSide: BorderSide.none,
                  child: Text('publish',
                      style: TextStyle(
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.bold))))
        ],
      ),
    );
  } //https://kabarak-ac-ke.zoom.us/j/88313840910?pwd=Q3g2L2J6UnFPWlNRL3UzaEFseVJCZz09
}

class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String url;
  final String comment;
  final Timestamp timestamp;

  const Comment(
      {Key key,
      this.username,
      this.userId,
      this.url,
      this.comment,
      this.timestamp})
      : super(key: key);
  factory Comment.fromDocument(DocumentSnapshot document) {
    return Comment(
      username: document['username'],
      userId: document['userId'],
      url: document['url'],
      comment: document["comment"],
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
                title: Text(username + ":" + comment,
                    style: TextStyle(fontSize: 18, color: Colors.black)),
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(url),
                ),
                subtitle: Text(tAgo.format(timestamp.toDate()),
                    style: TextStyle(
                      color: Colors.black,
                    )),
              )
            ],
          )),
    );
  }
}
