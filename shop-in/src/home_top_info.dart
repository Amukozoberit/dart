import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:newApp/pages/DesignedHome.dart';
import 'package:newApp/pages/HomePage.dart';
import 'package:newApp/pages/SearchPage.dart';
import 'package:newApp/pages/UploadPage.dart';
import 'package:newApp/shop-in/src/app.dart';
import 'package:newApp/webrecipes/Homes.dart';
//import 'package:carousel_pro';

class GroceryHome extends StatefulWidget {
  @override
  _GroceryHomeState createState() => _GroceryHomeState();
}

class _GroceryHomeState extends State<GroceryHome> {
  PageController pagecontroller;
  String locationMessage = "";
  getCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark mPlaceMark = placemarks[0];

    String completeadress =
        '${mPlaceMark.subThoroughfare}, ${mPlaceMark.thoroughfare},${mPlaceMark.subLocality} ${mPlaceMark.locality},${mPlaceMark.subAdministrativeArea} ${mPlaceMark.administrativeArea},${mPlaceMark.postalCode} ${mPlaceMark.country}';
    String specificAdress = '${mPlaceMark.subLocality} ${mPlaceMark.country}';
    print(specificAdress);

    setState(() {
      locationMessage = specificAdress;
    });
  }

  @override
  void dispose() {
    pagecontroller.dispose();
    super.dispose();
  }

  @override
  @override
  void initState() {
    super.initState();
    pagecontroller = PageController();
    getCurrentLocation();
  }

  onTapPageChange(int pageIndex) {
    pagecontroller.animateToPage(pageIndex,
        duration: Duration(milliseconds: 400), curve: Curves.bounceInOut);
  }

  whenPagechanges(int pageIndex) {
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }

  int getPageIndex = 0;
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
      appBar: AppBar(
          backgroundColor: Colors.blueGrey[900],
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "CookHub",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  //   fontFamily: 'Overpass'),
                ),
              ),
              Text("Groceries",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                    // fontFamily: 'Overpass'),
                  )),
            ],
          ),

          //title: Text('CookHub' + 'Recipes'),
          //centerTitle: true,
          actions: [Icon(Icons.add_shopping_cart_outlined)]),
      body: Column(
        children: [
          
         // Expanded(child: image_caurosel),
          Expanded(
            child: PageView(
              children: <Widget>[
                HomeScreen(),

                // ViewImages(),
                HomeScreen(),
                UploadPhotoPage(currentUser),
                // globalKey: _scaffoldKey,

                //NotificationsPage(),
                //ProfilePage(userProfileId: currentUser.id),
                Home(),
                //QuestionPage(gCurrentUser: currentUser),
              ],
              controller: pagecontroller,
              onPageChanged: whenPagechanges,
              physics: NeverScrollableScrollPhysics(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: getPageIndex,
        onTap: onTapPageChange,
        backgroundColor: Colors.grey,
        activeColor: Colors.white,
        inactiveColor: Colors.black,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.add)),
          //BottomNavigationBarItem(icon: Icon(Icons.ring_volume)),
          //BottomNavigationBarItem(icon: Icon(Icons.person)),
          BottomNavigationBarItem(icon: Icon(Icons.collections)),
          //BottomNavigationBarItem(icon: Icon(Icons.help)),
        ],
      ),
    );
  }
}
