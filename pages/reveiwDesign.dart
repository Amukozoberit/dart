import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newApp/shop-in/src/pages/product_details.dart';

//List<ReviewDesign> cart = [];
ReviewDesign reviews;

class ReviewDesign extends StatefulWidget {
  final String id;
  final String review;
  // final String timestamp;
  final String url;
  final String username;
  const ReviewDesign({this.id, this.review, this.url, this.username});
  factory ReviewDesign.fromDocument(DocumentSnapshot documentSnapshot) {
    return ReviewDesign(
      id: documentSnapshot['id'],
      review: documentSnapshot['review'],
      url: documentSnapshot['url'],
      username: documentSnapshot['username'],
    );
  }
  @override
  _ReviewDesignState createState() =>
      _ReviewDesignState(this.id, this.review, this.url, this.username);
}

class _ReviewDesignState extends State<ReviewDesign> {
  final String id;
  final String review;

  final String url;
  final String username;

  _ReviewDesignState(this.id, this.review, this.url, this.username);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
      leading:Text(username),
      title:Text(review)

    );
  }
}
