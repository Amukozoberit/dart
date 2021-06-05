import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final textStyle = TextStyle(
    fontSize: 30.0,
    color: Colors.black26,
    fontFamily: 'Signatra',
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Container contShapes({String title}) {
    return Container(
      width: ScreenUtil().setWidth(450),
      margin: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 20),
      height: ScreenUtil().setHeight(550),
      decoration: BoxDecoration(
          color: Colors.orange.shade400,
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            IconButton(icon: Icon(Icons.collections, size: 50), onPressed: null)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget image_caurosel = new Container(
      height: ScreenUtil().setHeight(300),
      width: ScreenUtil().screenWidth,
      child: FittedBox(
        fit: BoxFit.cover,
        child: new Carousel(
          images: [
            AssetImage('images/burger.png'),
            AssetImage('images/onions2.png'),
            AssetImage('images/onions3.png'),
            AssetImage('images/onions4.png'),
          ],
          autoplay: true,
          animationCurve: Curves.fastOutSlowIn,
          animationDuration: Duration(milliseconds: 1000),
        ),
      ),
    );
    ScreenUtil.init(context,
        designSize: Size(1125, 2436), allowFontScaling: true);
    return Scaffold(
        //backgroundColor: Colors.white,

        body: ListView(
      children: [
        /*  Padding(
              padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(80),
                  left: ScreenUtil().setWidth(50),
                  right: ScreenUtil().setWidth(50)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('     '),
                    ClipOval(
                        clipper: MyClip(),
                        child: Image.network(
                          // "assets/images/hert.webp",
                          currentUser.url,
                          width: ScreenUtil().setWidth(160),
                          height: ScreenUtil().setHeight(160),
                          fit: BoxFit.cover,
                        )),
                  ])),*/
        // Expanded(child: image_caurosel),
        //image_caurosel,
        Padding(
          padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(70),
              left: ScreenUtil().setWidth(70),
              right: ScreenUtil().setWidth(105)),
          child: Text("What would you like to buy", style: textStyle),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(70),
              right: ScreenUtil().setWidth(70)),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'search by grocery name',
              hintStyle: TextStyle(color: Colors.black38),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(60),
              left: ScreenUtil().setWidth(70),
              right: ScreenUtil().setWidth(105)),
          child: Text("Categories", style: textStyle),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(70),
        ),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
              child: Card(
                  margin: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setHeight(20),
                    horizontal: ScreenUtil().setWidth(20),
                  ),
                  child: FittedBox(
                      fit: BoxFit.fill,
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: [
                          contShapes(title: 'fruits\nGrocery'),
                          contShapes(title: 'Vegetables\nGrocery'),
                          contShapes(title: 'Oils\nGrocery'),
                          contShapes(title: 'Paper foods\nGrocery'),
                          contShapes(title: 'Salad\nGrocery'),
                          contShapes(title: 'Dairy\nGrocery'),
                        ],
                      ))),
            )),
        SizedBox(
          height: ScreenUtil().setHeight(70),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(60),
              left: ScreenUtil().setWidth(70),
              right: ScreenUtil().setWidth(105)),
          child: Text("Explore our Groceries", style: textStyle),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(900),
          // child: displayProfilePost(),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(900),
          child: Align(
            alignment: Alignment.center,
            child: Text('Be your own chef ',
                style: TextStyle(
                  fontFamily: 'Signatra',
                  color: Colors.orange,
                  fontSize: 50,
                )),
          ),
        ),
      ],
    ));
  }
}

/*Scaffold(
        body: ListView(
      padding: EdgeInsets.only(top: 50, left: 20, right: 20),
      children: [
        ListTile(
          leading: Text('What would you like\n to buy', style: textStyle),
          trailing: Icon(Icons.add_shopping_cart),
        ),
        ListTile(
            leading: RaisedButton.icon(
                onPressed: null,
                icon: Icon(Icons.location_pin),
                label: Text(locationMessage,style: textStyle,)))
      ],
    ));
  }

 
*/
