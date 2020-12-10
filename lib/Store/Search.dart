import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:malX/Models/item.dart';
import 'package:malX/Store/storehome.dart';
import 'package:malX/main.dart';
import '../Widgets/customAppBar.dart';

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => new _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  Future<QuerySnapshot> docList;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          bottom: PreferredSize(
            child: searchWidget(),
            preferredSize: Size(56, 56),
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          builder: (context, snap) {
            return snap.hasData
                ? ListView.builder(
                    itemCount: snap.data.documents.length,
                    itemBuilder: (context, index) {
                      ItemModel itemModel =
                          ItemModel.fromJson(snap.data.documents[index].data);
                      return sourceInfo(itemModel, context);
                    },
                  )
                : Text("No data ...");
          },
          future: docList,
        ),
      ),
    );
  }

  Widget searchWidget() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.grey, Colors.green],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(
                Icons.search,
                color: Colors.green,
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 8),
                child: TextField(
                  onChanged: (value) {
                    startSearching(value);
                  },
                  decoration: InputDecoration.collapsed(hintText: "Search ..."),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future startSearching(String query) async {
    docList = Firestore.instance
        .collection("items")
        .where("shortinfo", isGreaterThanOrEqualTo: query.trim())
        .getDocuments();
  }
}

Widget buildResultCard(data) {
  return Card();
}
