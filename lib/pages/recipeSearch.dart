import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:newApp/pages/HomePage.dart';
import 'package:newApp/widgets/PostWidget.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String name = "";
  List<Post> posts;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
      ),
      body: Column(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  fillColor: Colors.blueGrey[900],
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search...'),
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: (name != "" && name != null)
                  ? retrieveSearchTimeLine()
                  : retrieveSearchTimeLine(),
              builder: (context, snapshot) {
                print(snapshot);
                return (snapshot.connectionState == ConnectionState.waiting)
                    ? Center(child: CircularProgressIndicator())
                    : StaggeredGridView.countBuilder(
                        crossAxisCount: 4,
                        itemCount: snapshot.data.documentID.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot data = snapshot.data;
                          return Card(
                            child: Column(
                              children: <Widget>[
                                Image.network(
                                  data['url'],
                                  width: 150,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                Text(
                                  data['description'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        staggeredTileBuilder: (int index) =>
                            new StaggeredTile.count(2, index.isEven ? 2 : 1),
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  retrieveSearchTimeLine() async {
    QuerySnapshot querySnapshot = await timelineReference
        .document(currentUser.id)
        .collection('timelinePosts')
        .where('searchKey', arrayContains: name)
        .orderBy("timestamp", descending: true)
        .getDocuments();

    List<Post> allPosts = querySnapshot.documents.map((doc) {
      //return Post.fromDocument(doc);
      //  print(doc['url']);
      return Post(
        postId: doc['postId'],
        ownerId: doc['ownerId'],
        //  timestamp: documentSnapshot['timestamp'],
        likes: doc['likes'],
        username: doc['username'],
        description: doc['description'],
        url: doc['url'],
      );
    }).toList();
    print(allPosts);
    if (this.mounted) {
      setState(() {
        this.posts = allPosts;
      });
    }
    print(posts);
    return posts;

//    print(posts.);
  }
}
