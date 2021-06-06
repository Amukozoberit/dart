import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:newApp/shop-in/src/pages/designer.dart';
import 'package:newApp/shop-in/src/pages/postStyle.dart';
import 'package:newApp/shop-in/src/pages/product_details.dart';
import 'package:newApp/widgets/ProgressWidget.dart';

class DesignPost extends StatefulWidget {
  @override
  _DesignPostState createState() => _DesignPostState();
}

class _DesignPostState extends State<DesignPost> {
  List<Designer> postList = [];

  bool loading = false;
  @override
  void initState() {
    super.initState();
    getAllPosts();
    getCart();
  }

  getCart() {
    print(cart.length);
    cart.take(cart.length);
  }

  void getAllPosts() async {
    QuerySnapshot q =
        await Firestore.instance.collection('products').getDocuments();
    int countPost = q.documents.length;
    print(countPost);
    postList = q.documents.map((doc) {
      return Designer.fromDocument(doc);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: displayProfilePost(),
    );
  }

  displayProfilePost() {
    if (loading) {
      return circularProgress();
    } else if (postList.isEmpty) {
      return circularProgress();
    } else if (postList.isNotEmpty) {
      //else if (posTorientation == "grid") {
      // List<GridTile> gridTilesList = [];

      /* return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: postList,
      );*/
      return SingleChildScrollView(
        //  scrollDirection: Axis.horizontal,
        child: StaggeredGridView.countBuilder(
          shrinkWrap: true,
          crossAxisCount: 4,
          itemCount: postList.length,
          itemBuilder: (BuildContext context, int index) {
            return FittedBox(
              fit: BoxFit.cover,
              child: Container(
                  height: ScreenUtil().setHeight(500),
                  width: ScreenUtil().setWidth(500),
                  child: Container(
                    //tag: name,

                    padding: const EdgeInsets.all(10.0),
                    child: Material(
                      child: GridTile(
                          footer: Container(
                            height: 50,
                            color: Colors.white60,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        postList[index].name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '',
                                        //"\$$postList[index].price",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: RaisedButton.icon(
                                    onPressed: () {
                                      // print('added');
                                      //add_to_cart(this.id);
                                      setState(() {
                                        if (!cart.contains(postList[index])) {
                                          cart.add(postList[index]);

                                          print('added');
                                          print(cart);
                                        } else {
                                          cart.remove(postList[index]);
                                          print('exists');
                                        }
                                      });
                                    },
                                    icon: Icon(
                                      cart.contains(postList[index])
                                          ? Icons.remove_shopping_cart
                                          : Icons.add_shopping_cart,
                                    ),
                                    label: Expanded(
                                      child: Text(
                                          cart.contains(postList[index])
                                              ? 'minus_cart'
                                              : 'add to cart',
                                          style: TextStyle(
                                              color: Colors.blueGrey[900])),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            /*ListTile(
                    leading: Text(
                      name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    title: Text(
                      "\$$price",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w800),
                    ),
                  ),*/
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return new ProductDetails(
                                  name: postList[index].name,
                                  new_price: postList[index].price,
                                  picture: postList[index].picture,
                                  // old_price: prod_old_price,
                                );
                              }));
                            },
                            child: Container(
                                width: 190.0,
                                height: 190.0,
                                decoration: new BoxDecoration(
                                    // shape: BoxShape.circle,
                                    borderRadius: BorderRadius.circular(28.0),
                                    image: new DecorationImage(
                                        fit: BoxFit.cover,
                                        image: new NetworkImage(
                                            postList[index].picture)))),
                          ) /* Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: ),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Image.network(
                        picture,
                        scale: 5,
                        // height: MediaQuery.of(context).size.height * 0.25 * 0.8,
                        //width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),*/
                          ),
                    ),
                  )),
            );
          },
          staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
      );
    }
  }
}
