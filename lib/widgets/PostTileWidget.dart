//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newApp/pages/PostScreenPage.dart';
import 'package:newApp/widgets/CImageWidget.dart';
import 'package:newApp/widgets/PostWidget.dart';

class PostTile extends StatelessWidget {
  final Post post;
  const PostTile({
    Key key,
    this.post,
  }) : super(key: key);

  displayFulPost(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PostScreenPage(postId: post.postId, userId: post.ownerId);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return //Text("Post Tile");
        GestureDetector(
      onTap: () {
        displayFulPost(context);
        print(post.url);
      },
      // child:CachedNetworkImage(post.url)
      child: Image.network(post.url),
    );
  }
}
