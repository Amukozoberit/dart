import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ViewImages extends StatelessWidget {
  List<NetworkImage> _listOfImages = <NetworkImage>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('CookHub'),
          backgroundColor: Colors.pink,
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Flexible(
                child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('images').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return StaggeredGridView.countBuilder(
                            crossAxisCount: 4,
                            itemCount: snapshot.data.documents.length,
                            staggeredTileBuilder: (int index) =>
                                StaggeredTile.fit(2),
                            mainAxisSpacing: 8.0,
                            crossAxisSpacing: 8.0,
                            itemBuilder: (BuildContext context, int index) {
                              _listOfImages = [];
                              for (int i = 0;
                                  i <
                                      snapshot.data.documents[index]
                                          .data['urls'].length;
                                  i++) {
                                _listOfImages.add(NetworkImage(snapshot
                                    .data.documents[index].data['urls'][i]));
                              }
                              return Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(10.0),
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    child: Carousel(
                                        boxFit: BoxFit.cover,
                                        images: _listOfImages,
                                        autoplay: true,
                                        indicatorBgPadding: 5.0,
                                        dotPosition: DotPosition.bottomCenter,
                                        animationCurve: Curves.fastOutSlowIn,
                                        animationDuration:
                                            Duration(milliseconds: 2000)),
                                  ),
                                  ListTile(
                                    leading: IconButton(
                                        icon: Icon(Icons.favorite),
                                        onPressed: null),
                                    title: IconButton(
                                        icon: Icon(Icons.comment),
                                        onPressed: null),
                                  ),
                                  Container(
                                    height: 1,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.red,
                                  )
                                ],
                              );
                            });
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }))
          ],
        ));
  }
}
