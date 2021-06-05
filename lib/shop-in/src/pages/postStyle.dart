import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:newApp/shop-in/src/pages/designer.dart';
import 'package:newApp/widgets/ProgressWidget.dart';

class PostStyle extends StatefulWidget {
  final Designer post;

  const PostStyle({Key key, this.post}) : super(key: key);
  @override
  _PostStyleState createState() => _PostStyleState();
}

class _PostStyleState extends State<PostStyle> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firestore.instance.collection('products').getDocuments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return circularProgress();
          else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              Designer post = Designer.fromDocument(snapshot.data);

              return Container(
                child: widget.post,
              );
            }
          }
        });
  }
}
