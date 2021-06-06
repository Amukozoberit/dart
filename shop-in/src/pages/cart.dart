import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:newApp/shop-in/src/pages/designer.dart';
import 'package:newApp/shop-in/src/pages/product_details.dart';

class Cart extends StatefulWidget {
  final List<Designer> cart;

  const Cart({Key key, this.cart}) : super(key: key);
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blueGrey[900],
          actions: [
            IconButton(
              icon: Icon(Icons.clear_all),
              //label:Text('clear all')
              onPressed: () {
                setState(() {
                  cart.clear();
                  cart.isEmpty;
                  Navigator.pop(context);
                });
              },
            ),
            Text('Clear all'),
          ],
        ),
        body: StaggeredGridView.countBuilder(
          shrinkWrap: true,
          crossAxisCount: 4,
          itemCount: widget.cart.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                //c borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: FittedBox(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            cart[index].name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '',
                                            //"\$$cart[index].price",
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
                                            if (!cart.contains(cart[index])) {
                                              cart.add(cart[index]);

                                              print('added');
                                              print(cart);
                                            } else {
                                              cart.remove(cart[index]);
                                              print('exists');
                                            }
                                          });
                                        },
                                        icon: Icon(
                                          cart.contains(cart[index])
                                              ? Icons.remove_shopping_cart
                                              : Icons.add_shopping_cart,
                                        ),
                                        label: Expanded(
                                          child: Text(
                                              cart.contains(cart[index])
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
                                      name: cart[index].name,
                                      new_price: cart[index].price,
                                      picture: cart[index].picture,
                                      // old_price: prod_old_price,
                                    );
                                  }));
                                },
                                child: Container(
                                    width: 190.0,
                                    height: 190.0,
                                    decoration: new BoxDecoration(
                                        // shape: BoxShape.circle,
                                        borderRadius:
                                            BorderRadius.circular(28.0),
                                        image: new DecorationImage(
                                            fit: BoxFit.cover,
                                            image: new NetworkImage(
                                                cart[index].picture)))),
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
                ));
          },
          staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ));
  }
}
