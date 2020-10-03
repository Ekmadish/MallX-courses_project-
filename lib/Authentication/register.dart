import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malX/Config/config.dart';
import 'package:malX/DialogBox/errorDialog.dart';
import 'package:malX/DialogBox/loadingDialog.dart';
import 'package:malX/Widgets/customTextField.dart';
import '../Store/storehome.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameInput = TextEditingController();
  final TextEditingController _emailInput = TextEditingController();
  final TextEditingController _passwordInput = TextEditingController();
  final TextEditingController _repasswordInput = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String userImageUrl = '';
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 10.0,
            ),
            InkWell(
              onTap: _selectAndPickImage,
              child: CircleAvatar(
                  radius: _screenWidth * 0.15,
                  backgroundColor: Colors.white,
                  backgroundImage:
                      _imageFile == null ? null : FileImage(_imageFile),
                  child: _imageFile == null
                      ? Icon(
                          Icons.add_a_photo,
                          color: Colors.grey,
                          size: _screenWidth * 0.15,
                        )
                      : null),
            ),
            SizedBox(
              height: 8.0,
            ),
            Form(
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.person,
                    controller: _nameInput,
                    hintText: "Name",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    data: Icons.email,
                    controller: _emailInput,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: _passwordInput,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: _repasswordInput,
                    hintText: "Confirm Password",
                    isObsecure: true,
                  ),
                ],
              ),
              key: _formKey,
            ),
            RaisedButton(
              color: Colors.grey,
              onPressed: () {
                uploadAndsaveimge();
              },
              child: Text(
                "Sign up",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: 4.0,
              width: _screenWidth * 0.8,
              color: Colors.green,
            ),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadAndsaveimge() async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: "please select a image",
            );
          });
    } else {
      _passwordInput.text == _repasswordInput.text
          ? _emailInput.text.isNotEmpty &&
                  _nameInput.text.isNotEmpty &&
                  _passwordInput.text.isNotEmpty &&
                  _repasswordInput.text.isNotEmpty
              ? uploadTostorage()
              : displayDialog("please fill up  ")
          : displayDialog('Password do not match');
    }
  }

  uploadTostorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog();
        });
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(imageFileName);
    StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      userImageUrl = urlImage;
      _registerUser();
    });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async {
    FirebaseUser firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(
            email: _emailInput.text.trim(),
            password: _passwordInput.text.trim())
        .then((auth) {
      firebaseUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(message: error.toString());
        },
      );
    });

    if (firebaseUser != null) {
      saveUserToFireSore(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future saveUserToFireSore(FirebaseUser fUser) async {
    Firestore.instance.collection("users").document(fUser.uid).setData({
      'uid': fUser.uid,
      'name': _nameInput.text.trim(),
      'email': fUser.email,
      'url': userImageUrl,
      EcommerceApp.userCartList: ["garbageValue"]
    });

    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userUID, fUser.uid);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userEmail, fUser.email);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userName, _nameInput.text);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userAvatarUrl, userImageUrl);
    await EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ["garbageValue"]);
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(message: msg);
        });
  }

  Future<void> _selectAndPickImage() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }
}
