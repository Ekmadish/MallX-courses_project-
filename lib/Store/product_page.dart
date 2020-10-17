import 'package:flutter/material.dart';
import 'package:malX/Models/item.dart';
import 'package:malX/Widgets/customAppBar.dart';
import 'package:malX/Widgets/myDrawer.dart';

class ProductPage extends StatefulWidget {
  final ItemModel iteModel;
  ProductPage({this.iteModel});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int auntityOfItem = 1;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.network(widget.iteModel.thumbnailUrl),
                      ),
                      Container(
                        child: SizedBox(
                          height: 1.0,
                          width: double.infinity,
                        ),
                        color: Colors.green[300],
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.iteModel.title,
                            style: boldTextStyle,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            widget.iteModel.longDescription,
                            // style: boldTextStyle,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            " ₸  " + widget.iteModel.price.toString(),
                            style: boldTextStyle,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Center(
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.grey, Colors.green],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(0.0, 0.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          width: MediaQuery.of(context).size.width - 40.0,
                          height: 50.0,
                          child: Center(
                            child: Text(
                              "Add to Cart",
                              style: TextStyle(
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
