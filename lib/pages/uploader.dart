import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:newApp/models/user.dart';

import 'package:newApp/pages/utilis.dart';

class UploadImages extends StatefulWidget {
  final User gCurrentUser;

  const UploadImages({Key key, this.gCurrentUser}) : super(key: key);

  @override
  _UploadImagesState createState() => new _UploadImagesState();
}

class _UploadImagesState extends State<UploadImages> {
  List<Asset> images = List<Asset>();
  List<String> imageUrls = <String>[];
  String _error = 'No Error Dectected';
  bool isUploading = false;
  final _gloabalKey = GlobalKey<ScaffoldState>();
  final descriptiontextEditingControler = TextEditingController();
  final ingtextEditingControler = TextEditingController();
  final stepstextEditingControler = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        print(asset.getByteData(quality: 100));
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: ThreeDContainer(
            backgroundColor: MultiPickerApp.darker,
            backgroundDarkerColor: MultiPickerApp.darker,
            height: 50,
            width: 50,
            borderDarkerColor: MultiPickerApp.pauseButton,
            borderColor: MultiPickerApp.pauseButtonDarker,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: AssetThumb(
                asset: asset,
                width: 300,
                height: 300,
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        key: _gloabalKey,
        appBar: AppBar(
          title: Text('uploads page'),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: loadAssets,
                        child: ThreeDContainer(
                          width: 130,
                          height: 50,
                          backgroundColor: MultiPickerApp.navigateButton,
                          backgroundDarkerColor: MultiPickerApp.background,
                          child: Center(
                              child: Text(
                            "Pick images",
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (images.length == 0) {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    backgroundColor:
                                        Theme.of(context).backgroundColor,
                                    content: Text("No image selected",
                                        style: TextStyle(color: Colors.white)),
                                    actions: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: ThreeDContainer(
                                          width: 80,
                                          height: 30,
                                          backgroundColor:
                                              MultiPickerApp.navigateButton,
                                          backgroundDarkerColor:
                                              MultiPickerApp.background,
                                          child: Center(
                                              child: Text(
                                            "Ok",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                        ),
                                      )
                                    ],
                                  );
                                });
                          } else {
                            SnackBar snackbar = SnackBar(
                                content: Text('Please wait, we are uploading'));
                            _gloabalKey.currentState.showSnackBar(snackbar);
                            uploadImages(
                                descriptiontextEditingControler.text,
                                ingtextEditingControler.text,
                                stepstextEditingControler.text);
                          }
                        },
                        child: ThreeDContainer(
                          width: 130,
                          height: 50,
                          backgroundColor: MultiPickerApp.navigateButton,
                          backgroundDarkerColor: MultiPickerApp.background,
                          child: Center(
                              child: Text(
                            "Upload Images",
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: buildGridView(),
                  ),
                  Container(
                      color: Colors.black,
                      child:
                          //InkWell(onTap: loadAssets, child: Text('pick images')),
                          RaisedButton(
                        onPressed: null,
                        color: Colors.black,
                        textColor: Colors.white,
                        child: Row(
                          children: <Widget>[
                            Text('description'),
                          ],
                        ),
                      )),
                  TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: TextStyle(color: Colors.black),
                    controller: descriptiontextEditingControler,
                    decoration: InputDecoration(
                      hintText: 'type the description here',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                  Container(
                      color: Colors.black,
                      child:
                          //InkWell(onTap: loadAssets, child: Text('pick images')),
                          RaisedButton(
                        onPressed: null,
                        color: Colors.black,
                        textColor: Colors.white,
                        child: Row(
                          children: <Widget>[
                            Text('ingridients'),
                          ],
                        ),
                      )),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: TextStyle(color: Colors.black),
                      controller: stepstextEditingControler,
                      decoration: InputDecoration(
                        hintText: 'type the ingridients here',
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                      color: Colors.black,
                      child:
                          //InkWell(onTap: loadAssets, child: Text('pick images')),
                          RaisedButton(
                        onPressed: null,
                        color: Colors.black,
                        textColor: Colors.white,
                        child: Row(
                          children: <Widget>[
                            Text('Steps'),
                          ],
                        ),
                      )),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: TextStyle(color: Colors.black),
                      controller: ingtextEditingControler,
                      decoration: InputDecoration(
                        hintText: 'type the steps here',
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  void uploadImages(String description, String ingridients, String steps) {
    for (var imageFile in images) {
      postImage(imageFile).then((downloadUrl) {
        imageUrls.add(downloadUrl.toString());
        if (imageUrls.length == images.length) {
          String documnetID = DateTime.now().millisecondsSinceEpoch.toString();
          Firestore.instance.collection('images').document(documnetID).setData({
            'urls': imageUrls,
            'ownerId': widget.gCurrentUser.id,
            'timestamp': DateTime.now(),
            "likes": {},
            "username": widget.gCurrentUser.username,
            "description": description,
            "ing": ingridients,
            'steps': steps,
          }).then((_) {
            SnackBar snackbar =
                SnackBar(content: Text('Uploaded Successfully'));
            _gloabalKey.currentState.showSnackBar(snackbar);
            setState(() {
              images = [];
              imageUrls = [];
            });
          });
        }
      }).catchError((err) {
        print(err);
      });
    }
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Upload Image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      print(resultList.length);
      print((await resultList[0].getThumbByteData(122, 100)));
      print((await resultList[0].getByteData()));
      print((await resultList[0].metadata));
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      images = resultList;
      _error = error;
    });
  }

  Future<dynamic> postImage(Asset imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask =
        reference.putData((await imageFile.getByteData()).buffer.asUint8List());
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    print(storageTaskSnapshot.ref.getDownloadURL());
    return storageTaskSnapshot.ref.getDownloadURL();
  }
}
