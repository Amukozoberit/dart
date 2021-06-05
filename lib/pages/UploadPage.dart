/*//import 'dart:html';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:newApp/models/user.dart';
import 'package:newApp/widgets/ProgressWidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as ImD;
import 'HomePage.dart';

class UploadPage extends StatefulWidget {
  final User gCurrentUser;

  const UploadPage({Key key, this.gCurrentUser}) : super(key: key);

  //const UploadPage(this.gCurrentUser);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  File file;
  List<Asset> images = List<Asset>();
  bool uploading = false;
  String postId = Uuid().v4();
  List<String> ing = [];
  TextEditingController descriptionTextEditingController =
      TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();

  captureImageWithCamera() async {
    Navigator.pop(context);
    String imagefile;
    try {
      final imagefile = await picker.getImage(
        source: ImageSource.camera,
        maxHeight: 480,
        maxWidth: 970,
      );
    } on Exception catch (e) {
      String error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      this.file = File(imagefile);
    });
  }

  ImagePicker picker = ImagePicker();
  pickImageWithGallery() async {
    Navigator.pop(context);
    String imagefile;
    try {
      final imagefile = await picker.getImage(
        source: ImageSource.gallery,
        maxHeight: 480,
        maxWidth: 970,
      );
    } on Exception catch (e) {
      String error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      this.file = File(imagefile);
    });
  }

  takeImage(ncontext) {
    return showDialog(
        context: ncontext,
        builder: (context) {
          return Card(
            color: Theme.of(context).accentColor,
            child: SimpleDialog(
              title: Text(
                'new post',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              children: [
                SimpleDialogOption(
                  child: Text('Camera Capture',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  onPressed: captureImageWithCamera,
                  // onPressed:pickImageWithGallery,
                ),
                SimpleDialogOption(
                  child: Text('gallery Source',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  onPressed: null,
                ),
                SimpleDialogOption(
                  child: Text('Cancel',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        });
  }

  displayUploadScreen() {
    return Container(
      color: Theme.of(context).accentColor.withOpacity(0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate, color: Colors.grey, size: 200.0),
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: RaisedButton(
                onPressed: () {
                  takeImage(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9.0),
                ),
                child: Text(
                  'upload image',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                color: Colors.grey,
              )),
        ],
      ),
    );
  }

  contolrUploadSave() async {
    setState(() {
      uploading = true;
    });
    await compressingPhoto();
    String downloadUrl = await uploadPhoto(file);
    savePostInfoToFireStore(downloadUrl, descriptionTextEditingController.text,
        locationTextEditingController.text);
    //  descriptionTEditingController.clear();
    descriptionTextEditingController.clear();
    locationTextEditingController.clear();
    setState(() {
      file = null;
      uploading = false;
      postId = Uuid().v4();
    });
  }

  //List<String> list = [];
  savePostInfoToFireStore(String url, String description, String ingridients) {
    //FirebaseUser htu=User.id;

    postsReference
        .document(widget.gCurrentUser.id)
        .collection('userPosts')
        .document(postId)
        .setData({
      'postId': postId,
      'ownerId': widget.gCurrentUser.id,
      'timestamp': DateTime.now(),
      "likes": {},
      "username": widget.gCurrentUser.username,
      "description": description,
      "url": url,
      "ing": ingridients,
    });
  }

  Future<String> uploadPhoto(mImageFile) async {
    StorageUploadTask mstorageUploadTak =
        storageReference.child('post_$postId.jpg').putFile(mImageFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await mstorageUploadTak.onComplete;
    String downloadurl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadurl;
  }

  compressingPhoto() async {
    final tempDirectory = await getTemporaryDirectory();
    final path = tempDirectory.path;
    // ImD.Image=Image
    ImD.Image DImageFile = ImD.decodeImage(file.readAsBytesSync());
    final compressedImagefile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(ImD.encodeJpg(DImageFile, quality: 60));
    setState(() {
      file = compressedImagefile;
    });
  }

  displayUploadForm() {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor:
        backgroundColor: Colors.pink,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: clearPostImage,
          color: Colors.white,
        ),
        title: Text(
          'new post',
          style: TextStyle(
              fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          FlatButton(
              onPressed:
                  //print('pressed');
                  uploading ? null : () => contolrUploadSave(),
              child: Text(
                'share',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
      body: ListView(
        children: [
          uploading ? linearProgress() : Text(''),
          Container(
              height: 230.0,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                  child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(file),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )))),
          Padding(
            padding: EdgeInsets.only(top: 12.0),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(widget.gCurrentUser.url),
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: descriptionTextEditingController,
                decoration: InputDecoration(
                  hintText: 'description',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading:
                Icon(Icons.person_pin_circle, color: Colors.white, size: 36.0),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: locationTextEditingController,
                decoration: InputDecoration(
                  hintText: 'type the ingridients here',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  clearPostImage() {
    setState(() {
      file = null;
      descriptionTextEditingController.clear();
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true; //throw Unimplemen
  @override
  Widget build(BuildContext context) {
    //return Text("Here goes Upload Page.");
    return file == null ? displayUploadScreen() : displayUploadForm();
  }
}
*/
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:newApp/models/user.dart';
import 'package:newApp/pages/HomePage.dart';
import 'package:newApp/pages/TimeLinePage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:image/image.dart' as ImD;

class UploadPhotoPage extends StatefulWidget {
  final User gCurrentUser;
  const UploadPhotoPage(
    this.gCurrentUser,
  );

  State<StatefulWidget> createState() {
    return _uploadPhotoPageState();
  }
}

class _uploadPhotoPageState extends State<UploadPhotoPage> {
  //FileImage sampleImage;
  File sampleImage;
  String url;
  final formKey = GlobalKey<FormState>();

  String postId = Uuid().v4();
  bool uploading = false;
  //String user;
  GlobalKey globalkey = GlobalKey<ScaffoldState>();
  File file;
  TextEditingController descriptionTextEditingController =
      TextEditingController();
  TextEditingController stepsTextEditingController = TextEditingController();
  TextEditingController ingTextEditingController = TextEditingController();
  TextEditingController servTextEditingController = TextEditingController();
  TextEditingController prepTextEditingController = TextEditingController();
  TextEditingController gridTextEditingController = TextEditingController();
  final picker = ImagePicker();
  //final LostData response = await sampleImage.getLostData();
  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (this.mounted) {
      setState(() {
        sampleImage = tempImage;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    retrieveLostData();
  }

  // final ImagePicker _picker=getImage()
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      // backgroundColor: Colors.white,

      body: new Center(
        child: sampleImage == null ? Text('select an image') : enableUpload(),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: getImage == null ? retrieveLostData() : getImage,
        tooltip: 'user.add image',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }

  enableUpload() {
    return Scaffold(
      key: globalkey,
      body: new Form(
          key: formKey,
          child: ListView(
            // crossAxisAlignment=3,
            children: <Widget>[
              Card(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                /* child: Container(
                  height: 310,
                  width: 310,*/

                child: Image.file(
                  sampleImage,
                  height: 310.0,
                  width: 310,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 15.0),
              Container(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(widget.gCurrentUser.url),
                  ),
                  title: Text(widget.gCurrentUser.email),
                ),
              ),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: descriptionTextEditingController,
                  decoration: new InputDecoration(
                      hintText: 'Description',
                      hintStyle: TextStyle(color: Colors.white)),
                  /* validator: (descriptionTextEditingController) {
                    return descriptionTextEditingController.isEmpty
                        ? 'Description required'
                        : null;
                  },*/
                ),
              ),
              SizedBox(height: 15.0),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: ingTextEditingController,
                  decoration: new InputDecoration(labelText: 'ingridients'),
                ),
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: stepsTextEditingController,
                  decoration: new InputDecoration(labelText: 'Steps'),
                ),
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: prepTextEditingController,
                  decoration: new InputDecoration(labelText: 'preparationTime'),
                ),
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: servTextEditingController,
                  decoration:
                      new InputDecoration(labelText: 'number of people'),
                ),
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: gridTextEditingController,
                  decoration: new InputDecoration(
                      labelText: 'Tell your reader what to buy'),
                ),
              ),
              RaisedButton(
                  elevation: 10.0,
                  child: Text('add a new post'),
                  textColor: Colors.white,
                  color: Colors.pink,
                  onPressed: () {
                    SnackBar snackbar = SnackBar(
                      content: Text('please wait we are uploading'),
                      duration: Duration(seconds: 5),
                    );
                    Scaffold.of(context).showSnackBar(snackbar);

                    contolrUploadSave();
                    SnackBar snackba = SnackBar(
                      content: Text('uploading sucesful'),
                      duration: Duration(seconds: 5),
                    );
                    Scaffold.of(context).showSnackBar(snackba);
                  })
            ],
          )),
    );
  }

  Future<bool> validateAndSave() async {
    final form = await formKey.currentState;
    if (form.validate()) {
      form.save();
    } else {
      return false;
    }
  }

  savePostInfoToFireStore(String url, String description, String ingridients,
      String steps, String prep, String serve, String buylist) {
    //FirebaseUser htu=User.id;

    postsReference
        .document(widget.gCurrentUser.id)
        .collection('userPosts')
        .document(postId)
        .setData({
      'postId': postId,
      'ownerId': widget.gCurrentUser.id,
      'timestamp': DateTime.now(),
      "likes": {},
      "username": widget.gCurrentUser.username,
      "description": description,
      "url": url,
      "ing": ingridients,
      'steps': steps,
      'prep': prep,
      'serve': serve,
      'buylist': buylist,
    });
  }

  Future<String> uploadPhoto(mImageFile) async {
    StorageUploadTask mstorageUploadTak =
        storageReference.child('post_$postId.jpg').putFile(mImageFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await mstorageUploadTak.onComplete;
    String downloadurl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadurl;
  }

  compressingPhoto() async {
    final tempDirectory = await getTemporaryDirectory();
    final path = tempDirectory.path;
    // ImD.Image=Image
    // ignore: non_constant_identifier_names
    ImD.Image DImageFile = ImD.decodeImage(file.readAsBytesSync());
    final compressedImagefile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(ImD.encodeJpg(DImageFile, quality: 60));
    setState(() {
      file = compressedImagefile;
    });
  }

  contolrUploadSave() async {
    setState(() {
      uploading = true;
    });
    //await compressingPhoto();
    String downloadUrl = await uploadPhoto(sampleImage);
    savePostInfoToFireStore(
        downloadUrl,
        descriptionTextEditingController.text,
        ingTextEditingController.text,
        stepsTextEditingController.text,
        prepTextEditingController.text,
        servTextEditingController.text,
        gridTextEditingController.text);
    //  descriptionTEditingController.clear();

    descriptionTextEditingController.clear();
    ingTextEditingController.clear();
    stepsTextEditingController.clear();
    gridTextEditingController.clear();
    setState(() {
      sampleImage = null;
      uploading = false;
      postId = Uuid().v4();
    });
  }

  void goToHomePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new TimeLinePage(
        gCurrentUser: currentUser,
      );
    }));
  }

  Future<void> retrieveLostData() async {
    //final LostDataResponse response = await ImagePicker.retrieveLostData();
    final LostData response = await picker.getLostData();
    if (response == null) {
      return;
    }
  }
}
