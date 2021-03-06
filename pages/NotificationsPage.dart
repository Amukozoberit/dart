import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newApp/pages/PostScreenPage.dart';
import 'package:newApp/widgets/HeaderWidget.dart';
import 'package:newApp/widgets/ProgressWidget.dart';
import 'HomePage.dart';
import 'ProfilePage.dart';
import 'package:timeago/timeago.dart' as tAgo;

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  retrieveNotifications() async {
    QuerySnapshot querysnapshot = await activityFeedReference
        .document(currentUser.id)
        .collection('feedItems')
        .orderBy('timestamp', descending: true)
        .limit(60)
        .getDocuments();
    List<NotificationsItem> notificationsItem = [];
    querysnapshot.documents.forEach((document) {
      notificationsItem.add(NotificationsItem.fromDocument(document));
    });
    return notificationsItem;
  }

  @override
  Widget build(BuildContext context) {
    //return Text('Here goes Activity Feed Page');
    return Scaffold(
      appBar: header(context, strTitle: 'Notifications'),
      body: Container(
        child: FutureBuilder(
          future: retrieveNotifications(),
          builder: (context, dataSnapshot) {
            if (!dataSnapshot.hasData) {
              return circularProgress();
            }
            return ListView(
              children: dataSnapshot.data,
            );
          },
        ),
      ),
    );
  }
}

String notificationItemText;
Widget mediaPreview;

class NotificationsItem extends StatelessWidget {
  final String username;
  final String type;
  final String postId;
  final String userId;
  final String userProfileImg;
  final String url;
  final Timestamp timestamp;

  final String commentData;

  const NotificationsItem(
      {Key key,
      this.username,
      this.type,
      this.commentData,
      this.postId,
      this.userId,
      this.userProfileImg,
      this.url,
      this.timestamp})
      : super(key: key);
  factory NotificationsItem.fromDocument(DocumentSnapshot documentSnapshot) {
    return NotificationsItem(
      username: documentSnapshot['username'],
      type: documentSnapshot['type'],
      commentData: documentSnapshot['commentData'],
      postId: documentSnapshot['postId'],
      userId: documentSnapshot['userId'],
      userProfileImg: documentSnapshot['userProfileImg'],
      url: documentSnapshot["url"],
      timestamp: documentSnapshot["timestamp"],
    );
  }
  displayUserProfile(BuildContext context, {String userProfileId}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProfilePage(
        userProfileId: userProfileId,
      );
    }));
  }

  configureMediaReview(context) {
    if (type == "comment" || type == "like") {
      mediaPreview = GestureDetector(
          onTap: () {
            displayFullPost(context);
          },
          child: Container(
              height: 50.0,
              width: 50.0,
              child: AspectRatio(aspectRatio: 16 / 9),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(url)))));
    } else {
      mediaPreview = Text("");
    }
    if (type == "like") {
      notificationItemText = "liked your post";
    } else if (type == "comment") {
      notificationItemText = "replied:$commentData";
    } else if (type == "follow") {
      notificationItemText = "Started  following:$commentData";
    } else {
      notificationItemText = 'Error,unknown type=$type';
    }
  }

  displayFullPost(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PostScreenPage(
        postId: postId,
        userId: userId,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    configureMediaReview(context);

    return Padding(
        padding: EdgeInsets.only(bottom: 2.0),
        child: Container(
            color: Colors.white,
            child: ListTile(
              title: GestureDetector(
                onTap: () {
                  displayUserProfile(context, userProfileId: userId);
                },
                child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                        style: TextStyle(fontSize: 14.0, color: Colors.black),
                        children: [
                          TextSpan(
                              text: username,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: " $notificationItemText"),
                        ])),
              ),
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(userProfileImg),
              ),
              subtitle: Text(
                tAgo.format(timestamp.toDate()),
                overflow: TextOverflow.ellipsis,
              ),
              trailing: mediaPreview,
            )));
  }
}
