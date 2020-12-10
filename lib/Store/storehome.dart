import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:malX/Config/config.dart';
import 'package:malX/Counters/cartitemcounter.dart';
import 'package:malX/Store/cart.dart';
import 'package:malX/Store/product_page.dart';
import 'package:provider/provider.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';
import 'package:malX/Widgets/theme.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.grey, Colors.green],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(0.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
            title: Text(
              'MallX',
              style: TextStyle(
                  fontSize: 24, color: Colors.white, fontFamily: 'Signatra'),
            ),
            centerTitle: true,
            actions: [
              Align(
                child: Consumer<ThemeNotifire>(
                  builder: (context, ThemeNotifire notifire, child) =>
                      IconButton(
                          icon: notifire.darkTheme
                              ? Icon(Icons.wb_sunny)
                              : Icon(Icons.nights_stay),
                          onPressed: () {
                            notifire.ToggleTheme();
                          }),
                ),
              ),
              Stack(
                // alignment: Alignment.bottomCenter,

                children: [
                  IconButton(
                    onPressed: () {
                      Route route =
                          MaterialPageRoute(builder: (c) => CartPage());
                      Navigator.push(context, route);
                    },
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.grey,
                    ),
                  ),
                  Positioned(
                    child: Stack(
                      children: [
                        Icon(
                          Icons.brightness_1,
                          size: 20,
                          color: Colors.red,
                        ),
                        Positioned(
                            top: 3.0,
                            bottom: 3.0,
                            left: 6.5,
                            child: Consumer<CartItemCounter>(
                                builder: (context, counter, _) {
                              return Text(
                                (EcommerceApp.sharedPreferences
                                            .getStringList(
                                                EcommerceApp.userCartList)
                                            .length -
                                        1)
                                    .toString(),
                                // counter.count.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500),
                              );
                            })),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          drawer: MyDrawer(),
          body: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: SearchBoxDelegate(),
              ),
              StreamBuilder(
                stream: Firestore.instance
                    .collection("items")
                    .limit(15)
                    .orderBy("publishedDate", descending: true)
                    .snapshots(),
                // initialData: initialData,
                builder: (BuildContext context, AsyncSnapshot datasnapshot) {
                  return !datasnapshot.hasData
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: circularProgress(),
                          ),
                        )
                      : SliverStaggeredGrid.countBuilder(
                          crossAxisCount: 1,
                          staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                          itemBuilder: (context, index) {
                            ItemModel model = ItemModel.fromJson(
                                datasnapshot.data.documents[index].data);
                            return sourceInfo(model, context);
                          },
                          itemCount: datasnapshot.data.documents.length);
                },
              ),
            ],
          )),
    );
  }
}

Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: () {
      Route route = MaterialPageRoute(
        builder: (c) => ProductPage(iteModel: model),
      );
      Navigator.push(context, route);
    },
    splashColor: Colors.lightGreenAccent,
    child: Padding(
      padding: EdgeInsets.all(6.0),
      child: Container(
        height: 190,
        width: width,
        child: Row(
          children: [
            Image.network(
              model.thumbnailUrl,
              width: 140,
              height: 140,
            ),
            SizedBox(
              width: 4.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            model.title,
                            style: TextStyle(
                                color: Colors.deepOrange, fontSize: 14.0),
                          ),
                        ),
                      ],
                      mainAxisSize: MainAxisSize.max,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            model.shortInfo,
                            style: TextStyle(
                                color: Colors.black54, fontSize: 12.0),
                          ),
                        ),
                      ],
                      mainAxisSize: MainAxisSize.max,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.blueGrey,
                        ),
                        alignment: Alignment.topLeft,
                        width: 40,
                        height: 43,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "50%",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.lightGreen,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                "OFF",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.lightGreen,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: 0.0,
                            ),
                            child: Row(
                              children: [
                                // Text(
                                // r"Origional Price : $")

                                Text(
                                  "Origional Price : ₸  ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  (model.price + model.price).toString(),
                                  // model.price.toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      decoration: TextDecoration.lineThrough),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 5.0,
                            ),
                            child: Row(
                              children: [
                                // Text(
                                // r"Origional Price : $")

                                Text(
                                  "New Price : ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '₸ ',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16),
                                ),
                                Text(
                                  model.price.toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Flexible(child: Container()),
                  Align(
                    alignment: Alignment.centerRight,
                    child: removeCartFunction == null
                        ? IconButton(
                            icon: Icon(
                              Icons.add_shopping_cart,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              checkItemInCart(model.shortInfo, context);
                            })
                        : IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              removeCartFunction();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StoreHome(),
                                ),
                              );
                            }),
                  ),
                  Divider(
                    height: 5,
                    color: Colors.green,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container(
    height: 15,
    width: width * .34,
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
      color: primaryColor,
      borderRadius: BorderRadius.all(
        Radius.circular(20),
      ),
      boxShadow: <BoxShadow>[
        BoxShadow(
          offset: Offset(0, 5),
          blurRadius: 10,
          color: Colors.grey[200],
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: Image.network(
        imgPath,
        height: 15,
        width: width * .34,
        fit: BoxFit.fill,
      ),
    ),
  );
}

void checkItemInCart(String productID, BuildContext context) {
  EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList)
          .contains(productID)
      ? Fluttertoast.showToast(msg: "Product already in cart")
      : addItemToCart(productID, context);
}

addItemToCart(String productID, BuildContext context) {
  List tempCartList =
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
  tempCartList.add(productID);

  EcommerceApp.firestore
      .collection(EcommerceApp.collectionUser)
      .document(
        EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      )
      .updateData({EcommerceApp.userCartList: tempCartList}).then((value) =>
          Fluttertoast.showToast(msg: "Item added to cart Successfuly ."));
  EcommerceApp.sharedPreferences
      .setStringList(EcommerceApp.userCartList, tempCartList);
  Provider.of<CartItemCounter>(context, listen: false).displayResult();
}
