import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:malX/Config/config.dart';
import 'package:malX/Counters/cartitemcounter.dart';
import 'package:malX/Store/storehome.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  final addressId;
  final totalAmount;

  const PaymentPage({Key key, this.addressId, this.totalAmount})
      : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.grey, Colors.green],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Image.asset("images/cash.png"),
              ),
              SizedBox(
                height: 10,
              ),
              FlatButton(
                onPressed: addOrderDetails(),
                color: Colors.white,
                textColor: Colors.white,
                child: Text(
                  "Place Order",
                  style: TextStyle(fontSize: 30),
                ),
                padding: EdgeInsets.all(0),
                splashColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  addOrderDetails() {
    orderdetaiLsForUsers({
      EcommerceApp.addressID: widget.addressId,
      EcommerceApp.totalAmount: widget.totalAmount,
      "orderBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "Cash on Delivery",
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
    });

    orderdetaiLsForAdmin({
      EcommerceApp.addressID: widget.addressId,
      EcommerceApp.totalAmount: widget.totalAmount,
      "orderBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "Cash on Delivery",
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
    }).whenComplete(() => {
          emptyCardNow(),
        });
  }

  emptyCardNow() async {
    await EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ["garbageValue"]);

    List tepmList =
        EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);

    Firestore.instance
        .collection("users")
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .updateData({
      EcommerceApp.userCartList: tepmList,
    }).then((value) {
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, tepmList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });

    SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        "Youre Order has been placed successfully.",
        style: TextStyle(color: Colors.lightGreen),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StoreHome()),
    );
    // Fluttertoast.showToast(msg: "");
  }

  Future orderdetaiLsForUsers(Map<String, dynamic> data) async {
    await EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
                data['orderTime'])
        .setData(data);
  }

  Future orderdetaiLsForAdmin(Map<String, dynamic> data) async {
    await EcommerceApp.firestore
        .collection(EcommerceApp.collectionOrders)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
                data['orderTime'])
        .setData(data);
  }
}
