import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newApp/shop-in/src/pages/product_details.dart';

List<Designer> cart = [];
Designer post;

class Designer extends StatefulWidget {
  final String brand;
  final String description;
  final String category;
  final String id;
  final String picture;
  final String name;
  final double price;
  final int quantity;

  const Designer(
      {Key key,
      this.brand,
      this.description,
      this.category,
      this.id,
      this.picture,
      this.name,
      this.price,
      this.quantity})
      : super(key: key);
  factory Designer.fromDocument(DocumentSnapshot documentSnapshot) {
    return Designer(
      brand: documentSnapshot['brand'],
      description: documentSnapshot['description'],
      category: documentSnapshot['category'],
      id: documentSnapshot['id'],
      picture: documentSnapshot['picture'],
      name: documentSnapshot['name'],
      price: documentSnapshot['price'],
      quantity: documentSnapshot['quantity'],
    );
  }
  @override
  _DesignerState createState() => _DesignerState(
        this.brand,
        this.description,
        this.category,
        // timestamp: this.timestamp,
        this.id,
        this.picture,
        this.name,
        this.price,
        this.quantity,

        // likeCount: getTotalNumberOfLikes(this.likes));
        //  likecount:}
      );
}

class _DesignerState extends State<Designer> {
  final String brand;
  final String description;
  final String category;
  final String id;
  final String picture;
  final String name;
  final double price;
  final int quantity;

  _DesignerState(this.brand, this.description, this.category, this.id,
      this.picture, this.name, this.price, this.quantity);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        height: ScreenUtil().setHeight(1000),
        width: ScreenUtil().setWidth(1000),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "\$$price",
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
                              print('deleted');
                              setState(() {
                                cart.remove(this.id);
                              });
                              //add_to_cart(this.id);
                            },
                            icon: Icon(cart.contains(this.id)
                                ? Icons.add_shopping_cart
                                : Icons.remove_shopping_cart),
                            label: Text(
                                cart.contains(this.id)
                                    ? 'add_cart'
                                    : 'minus_cart',
                                style: TextStyle(color: Colors.blueGrey[900]))),
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
                        name: name,
                        new_price: price,
                        picture: picture,
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
                              image: new NetworkImage(picture)))),
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
        ));
  }
}
