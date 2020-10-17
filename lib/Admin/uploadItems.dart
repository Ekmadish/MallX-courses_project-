import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malX/Admin/adminShiftOrders.dart';
import 'package:malX/Widgets/loadingWidget.dart';
import 'package:malX/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;

  File file;
  TextEditingController _discrptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _shortinfoController = TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool upLoading = false;

  @override
  Widget build(BuildContext context) {
    return file == null ? displayAdminHomeScreen() : displayUploadFormScreen();
  }

  displayAdminHomeScreen() {
    return Scaffold(
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
        leading: IconButton(
          icon: Icon(
            Icons.border_color,
            color: Colors.white,
          ),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
            Navigator.pushReplacement(context, route);
          },
        ),
        actions: [
          FlatButton(
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => SplashScreen());
              Navigator.pushReplacement(context, route);
            },
            child: Text(
              "Logout",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody() {
    return Container(
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
            Icon(
              Icons.shop_two,
              color: Colors.white,
              size: 200.0,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                onPressed: () => takeImage(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9.0),
                ),
                child: Text("Add new product",
                    style: TextStyle(fontSize: 20.0, color: Colors.white)),
                color: Colors.green,
              ),
            )
          ],
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: Text("Item Image",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                )),
            children: [
              SimpleDialogOption(
                  child: Text("Capture with camera",
                      style: TextStyle(
                        color: Colors.blueGrey,
                      )),
                  onPressed: captureWithCamera // capturePhotowithCamera,
                  ),
              SimpleDialogOption(
                child: Text("Select from gallery",
                    style: TextStyle(
                      color: Colors.blueGrey,
                    )),
                onPressed: captureWithGallery,
              ),
              SimpleDialogOption(
                  child: Text("Cancel",
                      style: TextStyle(
                        color: Colors.blueGrey,
                      )),
                  onPressed: () {
                    Navigator.pop(context);
                  } //Cancel ,
                  ),
            ],
          );
        });
  }

  captureWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);
    setState(() {
      file = imageFile;
    });
  }

  captureWithGallery() async {
    Navigator.pop(context);

    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = imageFile;
    });
  }

  displayUploadFormScreen() {
    return Scaffold(
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
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: clearForm),
        title: Text(
          "New product",
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        actions: [
          FlatButton(
            onPressed: upLoading ? null : () => uploadImmageAndsaveDb(),
            child: Text(
              "Add ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          upLoading ? linearProgress() : Text(" "),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(file),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0),
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.blueGrey,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepOrangeAccent),
                controller: _shortinfoController,
                decoration: InputDecoration(
                    hintText: 'Short info',
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none),
              ),
            ),
          ),
          Divider(
            color: Colors.blue,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.blueGrey,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepOrangeAccent),
                controller: _titleController,
                decoration: InputDecoration(
                    hintText: 'Title info',
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none),
              ),
            ),
          ),
          Divider(
            color: Colors.blue,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.blueGrey,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepOrangeAccent),
                controller: _discrptionController,
                decoration: InputDecoration(
                    hintText: 'Discrption',
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none),
              ),
            ),
          ),
          Divider(
            color: Colors.blue,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.blueGrey,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.deepOrangeAccent),
                controller: _priceController,
                decoration: InputDecoration(
                    hintText: 'Price',
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none),
              ),
            ),
          ),
          Divider(
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  clearForm() {
    setState(() {
      file = null;
      _discrptionController.clear();
      _priceController.clear();
      _titleController.clear();
      _shortinfoController.clear();
    });
  }

  uploadImmageAndsaveDb() async {
    setState(() {
      upLoading = true;
    });

    String imageDownloadUrl = await uploadItemImage(file);
    saveItemInfo(imageDownloadUrl);
  }

  saveItemInfo(String url) {
    final itemsRef = Firestore.instance.collection("items");
    itemsRef.document(productId).setData({
      "shortInfo": _shortinfoController.text.trim(),
      "longDescription": _discrptionController.text.trim(),
      "price": int.parse(_priceController.text),
      "publishedDate": DateTime.now(),
      "status": "availa",
      "thumbnailUrl": url,
      "title": _titleController.text.trim(),
    });

    setState(() {
      file = null;
      upLoading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _discrptionController.clear();
      _priceController.clear();
      _titleController.clear();
      _shortinfoController.clear();
    });
  }

  Future<String> uploadItemImage(mFileImage) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child("Items");
    StorageUploadTask uploadTask =
        storageReference.child("product_$productId.jpg").putFile(mFileImage);

    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadurl = await taskSnapshot.ref.getDownloadURL();
    return downloadurl;
  }
}
