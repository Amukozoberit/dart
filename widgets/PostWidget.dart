import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newApp/models/user.dart';
import 'package:newApp/pages/CommentsPage.dart';
import 'package:newApp/pages/HomePage.dart';
import 'package:newApp/pages/PostScreenPage.dart';
import 'package:newApp/pages/ProfilePage.dart';
import 'package:newApp/widgets/PostTileWidget.dart';
//import 'package:newApp/pages/PostScreenPage.dart';
//import 'package:newApp/widgets/CImageWidget.dart';
import 'package:newApp/widgets/ProgressWidget.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String timestamp;
  final dynamic likes;
  final String username;
  final String description;
  final String url;
  final String steps;
  final int likeCount;
  final String ing;
  final String serve;
  final String prep;
  final String buyList;

  const Post({
    Key key,
    this.postId,
    this.ownerId,
    this.timestamp,
    this.likes,
    this.username,
    this.description,
    this.url,
    this.steps,
    this.likeCount,
    this.ing,
    this.serve,
    this.prep,
    this.buyList,
  }) : super(key: key);
  factory Post.fromDocument(DocumentSnapshot documentSnapshot) {
    return Post(
      postId: documentSnapshot['postId'],
      ownerId: documentSnapshot['ownerId'],
      //  timestamp: documentSnapshot['timestamp'],
      likes: documentSnapshot['likes'],
      username: documentSnapshot['username'],
      description: documentSnapshot['description'],
      url: documentSnapshot['url'],
      steps: documentSnapshot['steps'],
      ing: documentSnapshot['ing'],
      prep: documentSnapshot['prep'],
      serve: documentSnapshot['serve'],
      buyList: documentSnapshot['buylist'],
    );
  }
  int getTotalNumberOfLikes(likes) {
    if (likes == null) {
      return 0;
    }
    int counter = 0;

    likes.values.forEach((eachValue) {
      if (eachValue == true) {
        counter = counter + 1;
      }
    });
    return counter;
  }

  @override
  _PostState createState() => _PostState(
      postId: this.postId,
      ownerId: this.ownerId,
      // timestamp: this.timestamp,
      likes: this.likes,
      username: this.username,
      description: this.description,
      url: this.url,
      likeCount: getTotalNumberOfLikes(this.likes));
  //  likecount:
}

class _PostState extends State<Post> {
  final String postId;
  final String ownerId;
  final String timestamp;
  final Map likes;
  final String username;
  final String description;
  final String url;
  int likeCount;
  bool isLike;
  bool showheart = false;
  final String currentOnlineUserId = currentUser.id;

  _PostState({
    this.postId,
    this.ownerId,
    this.timestamp,
    this.likes,
    this.username,
    this.description,
    this.url,
    this.likeCount,
  });

  @override
  Widget build(BuildContext context) {
    isLike = likes[currentOnlineUserId] == true;
    return Container(
        height: ScreenUtil().setHeight(1100),
        width: ScreenUtil().setWidth(800),
        decoration: BoxDecoration(
            //color: Colors.blueGrey[900],
            borderRadius: BorderRadius.all(Radius.circular(40.0))),
        child: Container(
            //tag: name,
            decoration: BoxDecoration(
                //color: Colors.blueGrey[900],
                borderRadius: BorderRadius.all(Radius.circular(40.0))),
            padding: const EdgeInsets.all(10.0),
            child: Material(
              child: GridTile(
                footer: Container(
                  height: ScreenUtil().setHeight(250),
                  color: Colors.white38,
                  child: createPostFooter(),
                ),
                header: Container(
                    height: 50, color: Colors.white38, child: createPostHead()),
                child: createPostPicture(),
              ),
            )));

    /*Padding(
        padding: EdgeInsets.only(bottom: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            createPostHead(),
            createPostPicture(),
            createPostFooter(),
          ],
        ));*/
  }

  createPostPicture() {
    return GestureDetector(
        // onTap:()=>PostTile(post:url),
        // onTap:,
        // onTap: () => PostTile(),
        onDoubleTap: () => controlUserLikePost(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
                decoration: new BoxDecoration(
                    // shape: BoxShape.circle,
                    // borderRadius: BorderRadius.circular(28.0),
                    image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: new NetworkImage(url, scale: 6)))),
            showheart
                ? Icon(
                    Icons.favorite,
                    size: 120.0,
                    color: Colors.pink,
                  )
                : Text(""),
          ],
        ) //likepost,
        );
  }

  controlUserLikePost() {
    bool _liked = likes[currentOnlineUserId] == true;
    if (_liked) {
      postsReference
          .document(ownerId)
          .collection('userPosts')
          .document(postId)
          .updateData({'likes.$currentOnlineUserId': false});
      removeLike();
      setState(() {
        likeCount = likeCount - 1;
        isLike = false;
        likes[currentOnlineUserId] = false;
      });
    } else if (!_liked) {
      postsReference
          .document(ownerId)
          .collection('userPosts')
          .document(postId)
          .updateData({'likes.$currentOnlineUserId': true});
      addlike();
      setState(() {
        likeCount = likeCount + 1;
        isLike = true;
        likes[currentOnlineUserId] = true;
        showheart = true;
        Timer(Duration(milliseconds: 200), () {
          showheart = false;
        });
      });
    }
  }

  addlike() {
    bool isNotPostOwner = currentOnlineUserId != ownerId;
    if (isNotPostOwner) {
      // activityfeedReference.document(ownerId).collec
      activityFeedReference
          .document(ownerId)
          .collection('feedItems')
          .document(postId)
          .setData({
        'type': "like",
        "username": currentUser.username,
        "userId": currentUser.id,
        'timestamp': DateTime.now(),
        "url": url,
        "postId": postId,
        "userProfileImg": currentUser.url,
      });
    }
  }

  removeLike() {
    bool isNotPostOwner = currentOnlineUserId != ownerId;
    if (isNotPostOwner) {
      activityFeedReference
          .document(ownerId)
          .collection('feedItems')
          .document(postId)
          .get()
          .then((document) {
        if (document.exists) {
          document.reference.delete();
        }
      });
    }
  }

  createPostFooter() {
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top: 40.0, left: 20)),
              GestureDetector(
                onTap: () {
                  controlUserLikePost();
                },
                child: Icon(isLike ? Icons.favorite : Icons.favorite_border,
                    size: 28.0, color: Colors.pink),
              ),
              Padding(padding: EdgeInsets.only(top: 40.0, left: 20)),
            ],
          ),
        ),
        Divider(height: 10),
        Expanded(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text(
                  likeCount == 1 ? '$likeCount like' : '$likeCount likes',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text(
                  '$description ',
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'by $username',
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  displayComments(context, postId, ownerId, url);
                },
                child: Icon(Icons.chat_bubble_outline,
                    size: 25, color: Colors.blueGrey[900]),
              )),
              Divider(height: 10),
            ],
          ),
        )
      ],
    );
  }

  displayComments(
      BuildContext context, String postId, String ownerId, String url) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CommentsPage(
          postId: postId, postOwnerId: ownerId, postImageUrl: url);
    }));
  }

  displayUserProfile(BuildContext context, {String userProfileId}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProfilePage(
        userProfileId: userProfileId,
      );
    }));
  }

  createPostHead() {
    return FutureBuilder(
      future: usersReference.document(ownerId).get(),
      //  initialData: InitialData,

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return circularProgress();
        else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            User user = User.fromDocument(snapshot.data);
            bool isPostOwner = currentOnlineUserId == ownerId;
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(user.url),
                backgroundColor: Colors.white,
              ),
              title: GestureDetector(
                  child: Text(
                    user.username,
                    style: TextStyle(
                        fontSize: 19,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    // print('to my profile');
                    displayUserProfile(context, userProfileId: user.id);
                  }),
              // child: Scaffold(
              trailing: isPostOwner
                  ? IconButton(
                      icon: Icon(Icons.more_vert, color: Colors.blueGrey[900]),
                      onPressed: () {
                        //print('deleted');
                        controlPostDelete(context);
                      })
                  : Text(''),
            );
          } else {
            return Center(child: Text("No data or it's empty"));
          }
        } else {
          return Center(child: Text("Neither waiting or done..."));
        }
      },
    );
  }

  controlPostDelete(BuildContext mContext) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title:
                Text("what do you want", style: TextStyle(color: Colors.white)),
            children: [
              SimpleDialogOption(
                child: Text("Delete ",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pop(context);
                  removeUserPost();
                },
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  removeUserPost() async {
    postsReference
        .document(ownerId)
        .collection('userPosts')
        .document(postId)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
    storageReference.child('post_$postId.jpg').delete();
    QuerySnapshot querySnapshot = await activityFeedReference
        .document(ownerId)
        .collection("feedItems")
        .where("postId", isEqualTo: postId)
        .getDocuments();
    querySnapshot.documents.forEach((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
    QuerySnapshot commentsquerySnapshot = await commentsReference
        .document(postId)
        .collection("comments")
        .getDocuments();
    commentsquerySnapshot.documents.forEach((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
  }
/*   return FutureBuilder(
      future: usersReference.document(ownerId).get(),
      //  initialData: InitialData,
      builder: (BuildContext context, datasnapshot) {
        if (!datasnapshot.data) {
          return circularProgress();
        }
        User user = User.fromDocument(datasnapshot.data);
        bool isPostOwner = currentOnlineUserId == ownerId;
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.url),
            backgroundColor: Colors.grey,
          ),
          title: GestureDetector(
              child: Text(
                user.username,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                print('to my profile');
              }),
          //  subtitle: Text,

          trailing: isPostOwner
              ? IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () {
                    print('deleted');
                  })
              : Text(''),
        );
      },
    );*/
}
