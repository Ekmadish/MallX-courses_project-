import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

final String title = 'MAL_X';

class _AuthenticScreenState extends State<AuthenticScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [Colors.lightBlue, Colors.lightBlue]),
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontFamily: 'Signatra'),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                text: "Login",
              ),
              Tab(
                icon: Icon(
                  Icons.perm_contact_calendar,
                  color: Colors.white,
                ),
                text: "Register",
              )
            ],
            indicatorColor: Colors.white30,
            indicatorWeight: 5.0,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black, Colors.black],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft),
          ),
          child: TabBarView(children: [
            Login(),
            Register(),
          ]),
        ),
      ),
    );
  }
}
