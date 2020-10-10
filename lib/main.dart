import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:malX/Authentication/authenication.dart';
import 'package:malX/Config/config.dart';
import 'package:malX/Store/storehome.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = Firestore.instance;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'malX',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.green,
        ),
        home: SplashScreen());
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    displaySplas();
  }

  displaySplas() async {
    Timer(Duration(seconds: 5), () async {});
    if (await EcommerceApp.auth.currentUser() != null) {
      Route route = MaterialPageRoute(builder: (_) => StoreHome());
      Navigator.pushReplacement(context, route);
    } else {
      Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());
      Navigator.pushReplacement(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.amber, Colors.deepOrange],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset("images/welcome.png"),
              SizedBox(
                height: 20,
              ),
              Text(
                "some text",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
