import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:malX/Address/address.dart';
import 'package:malX/Config/config.dart';
import 'package:malX/Models/address.dart';
import 'package:malX/main.dart';

String getOrderId = "";

class OrderDetails extends StatelessWidget {
  final String orderID;

  const OrderDetails({Key key, this.orderID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(),
    );
  }
}

class StatusBanner extends StatelessWidget {
  final bool status;

  const StatusBanner({Key key, this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;

    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Successful" : msg = "UnSuccessful";

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.grey, Colors.green],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_drop_down_circle),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            "Order placed" + msg,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 5,
          ),
          CircleAvatar(
            radius: 8,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShippingDetails extends StatelessWidget {
  final AddressModel model;

  const ShippingDetails({Key key, this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Details",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 90, vertical: 5),
          width: screenWidth,
          child: Table(
            children: [
              TableRow(
                children: [
                  KeyText(
                    msg: "Name",
                  ),
                  Text(model.name),
                ],
              ),
              TableRow(
                children: [
                  KeyText(
                    msg: "Phone nomber",
                  ),
                  Text(model.phoneNumber),
                ],
              ),
              TableRow(
                children: [
                  KeyText(
                    msg: "House Nomber",
                  ),
                  Text(model.flatNumber),
                ],
              ),
              TableRow(
                children: [
                  KeyText(
                    msg: "City",
                  ),
                  Text(model.city),
                ],
              ),
              TableRow(
                children: [
                  KeyText(
                    msg: "State",
                  ),
                  Text(model.state),
                ],
              ),
              TableRow(
                children: [
                  KeyText(
                    msg: "PinCode",
                  ),
                  Text(model.pincode),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: InkWell(
              child: Center(
                child: Text(
                  "Confirmed || Received",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              onTap: () => confirmedUserOrderReceived(context, getOrderId),
            ),
          ),
        )
      ],
    );
  }

  confirmedUserOrderReceived(BuildContext c, String id) {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .document(id)
        .delete();

    Fluttertoast.showToast(msg: "Order has been  Received");
    getOrderId = "";
    Navigator.pushAndRemoveUntil(
        c, MaterialPageRoute(builder: (c) => SplashScreen()), (route) => false);
  }
}
