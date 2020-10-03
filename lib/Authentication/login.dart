import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:malX/Admin/adminLogin.dart';
import 'package:malX/Config/config.dart';
import 'package:malX/DialogBox/errorDialog.dart';
import 'package:malX/DialogBox/loadingDialog.dart';
import 'package:malX/Widgets/customTextField.dart';
import '../Store/storehome.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailInput = TextEditingController();
  final TextEditingController _passwordInput = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
      return SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                child: Image.asset('images/login.png', width: 300, height: 100),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Form(
                child: Column(
                  children: [
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
                  ],
                ),
                key: _formKey,
              ),
              RaisedButton(
                color: Colors.grey,
                onPressed: () {
                  _emailInput.text.isNotEmpty && _passwordInput.text.isNotEmpty
                      ? _loginUser()
                      : showDialog(
                          context: context,
                          builder: (c) {
                            return ErrorAlertDialog(
                              message: "Please write email  and password",
                            );
                          });
                },
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Container(
                height: 4.0,
                width: _screenWidth * 0.8,
                color: Colors.green,
              ),
              SizedBox(
                height: 15.0,
              ),
              FlatButton.icon(
                label: Text(
                  "i'm Admin ",
                  style:
                      TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                icon: Icon(
                  Icons.nature_people,
                  color: Colors.blue,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminSignInPage(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(message: " Login please wait...");
        });
    FirebaseUser firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
            email: _emailInput.text.trim(),
            password: _passwordInput.text.trim())
        .then((authUser) {
      firebaseUser = authUser.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });
    if (firebaseUser != null) {
      readeData(firebaseUser).then((c) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future readeData(FirebaseUser fUser) async {
    await Firestore.instance
        .collection("users")
        .document(fUser.uid)
        .get()
        .then((datasnapShot) async {
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userUID, datasnapShot.data[EcommerceApp.userUID]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userEmail, datasnapShot.data[EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userName, datasnapShot.data[EcommerceApp.userName]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl,
          datasnapShot.data[EcommerceApp.userAvatarUrl]);

      List<String> cartList =
          datasnapShot.data[EcommerceApp.userCartList].cast<String>();
      await EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, cartList);
    });
  }
}
