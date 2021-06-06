import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String name = "";
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
            child: StreamBuilder<QuerySnapshot>(
              stream: (name != "" && name != null)
                  ? Firestore.instance
                      .collection('products')
                      .where("searchKey", arrayContains: name)
                      .snapshots()
                  : Firestore.instance.collection("products").snapshots(),
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.waiting)
                    ? Center(child: CircularProgressIndicator())
                    : StaggeredGridView.countBuilder(
                        crossAxisCount: 4,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot data =
                              snapshot.data.documents[index];
                          return Card(
                            child: Column(
                              children: <Widget>[
                                Image.network(
                                  data['picture'],
                                  width: 150,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                Text(
                                  data['name'],
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
}
