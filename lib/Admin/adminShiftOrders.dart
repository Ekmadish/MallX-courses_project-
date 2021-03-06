import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:malX/Admin/adminOrderCard.dart';
import 'package:malX/Config/config.dart';
import 'package:malX/Widgets/loadingWidget.dart';
import 'package:malX/Widgets/orderCard.dart';

class AdminShiftOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<AdminShiftOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
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
          centerTitle: true,
          title: Text(
            "My Orders",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.arrow_drop_down_circle,
                  color: Colors.white,
                ),
                onPressed: () {
                  SystemNavigator.pop();
                })
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection("orders").snapshots(),
            builder: (c, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (c, index) {
                        return FutureBuilder<QuerySnapshot>(
                          builder: (c, snap) {
                            return snap.hasData
                                ? AdminOrderCard(
                                    data: snap.data.documents,
                                    orderID: snapshot
                                        .data.documents[index].documentID,
                                    itemCount: snap.data.documents.length,
                                    orderBy: snapshot
                                        .data.documents[index].data["orderBy"],
                                    addressID: snapshot.data.documents[index]
                                        .data["addressID"],
                                  )
                                : Center(
                                    child: circularProgress(),
                                  );
                          },
                          future: Firestore.instance
                              .collection("items")
                              .where("shortInfo",
                                  whereIn: snapshot.data.documents[index]
                                      .data[EcommerceApp.productID])
                              .getDocuments(),
                        );
                      },
                    )
                  : Center(
                      child: circularProgress(),
                    );
            }),
      ),
    );
  }
}
