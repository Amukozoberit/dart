import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//my own imports

//import 'package:newApp/shop-in/src/components/horizontal_listview.dart';
//import 'package:newApp/shop-in/src/components/prodcuts.dart';
//import 'package:newApp/shop-in/src/db/app_provider.dart';
import 'package:newApp/shop-in/src/pages/Products.dart.dart';
import 'package:newApp/shop-in/src/pages/cart.dart';
import 'package:newApp/shop-in/src/pages/designer.dart';
import 'package:newApp/shop-in/src/pages/search.dart';
import 'package:newApp/shop-in/src/pages/searchService.dart';

//import 'package:newApp/shop-in/src/pages/admin.dart';
//import 'package:newApp/shop-in/src/pages/cart.dart';
//import 'package:newApp/shop-in/src/pages/login.dart';
bool isactive = false;

class HomPage extends StatefulWidget {
  @override
  _HomPageState createState() => _HomPageState();
}

class _HomPageState extends State<HomPage> {
  //DesignPost designPost = DesignPost();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget image_caqrousel = new Container(
      height: ScreenUtil().setHeight(500),
      width: ScreenUtil().screenWidth,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          Image.asset('assets/images/onions4.jpg'),
          Image.asset('assets/images/burger.png'),
          Image.asset('assets/images/burger.png'),
          Image.asset('assets/images/burger.png'),
          Image.asset('assets/images/burger.png'),
        ],
        autoplay: true,
//      animationCurve: Curves.fastOutSlowIn,
//      animationDuration: Duration(milliseconds: 1000),
        dotSize: 4.0,
        indicatorBgPadding: 2.0,
      ),
    );

    return Scaffold(
      appBar: new AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
        title: Text('CookHubGroceries'),
        actions: <Widget>[
          new IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Search();
              }));
            },
          ),
          InkWell(
            child: new Icon(cart.isEmpty
                ? Icons.shopping_cart_outlined
                : Icons.shopping_cart_outlined),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Cart(cart: cart);
              }));
            },
          ),
        ],
      ),
      body: new Column(
        children: <Widget>[
          //image carousel begins here
//        image_carousel,
          // Flexible(child: image_caqrousel),
          //padding widget
          new Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
                alignment: Alignment.centerLeft, child: new Text('Categories')),
          ),

          //Horizontal list view begins here
          // HorizontalList(),

          //padding widget
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                alignment: Alignment.centerLeft,
                child: new Text('Recent products')),
          ),

          //grid view
          Flexible(child: DesignPost()),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
