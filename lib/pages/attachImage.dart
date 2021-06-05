import 'package:flutter/material.dart';
import 'uploader.dart';
import 'viewpage.dart';

class AttachImage extends StatefulWidget {
  @override
  _AttachImageState createState() => _AttachImageState();
}

class _AttachImageState extends State<AttachImage> {
  final _globalKey = GlobalKey<ScaffoldState>();
  @override




  
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _globalKey,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('Multiple Images'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.image),
                text: 'Images',
              ),
              Tab(
                icon: Icon(Icons.cloud_upload),
                text: "Upload Images",
              ),
            ],
            indicatorColor: Colors.pink,
            indicatorWeight: 5.0,
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ViewImages(),
            UploadImages(
         
            ),
          ],
        ),
      ),
    );
  }
}
