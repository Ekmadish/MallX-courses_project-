import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:malX/Admin/uploadItems.dart';
import 'package:malX/Authentication/authenication.dart';
import 'package:malX/DialogBox/errorDialog.dart';
import 'package:malX/Store/storehome.dart';
import 'package:malX/Widgets/customTextField.dart';

class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        title: Text(
          title,
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontFamily: 'Signatra'),
        ),
        centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final TextEditingController _adminIdlInput = TextEditingController();
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
              child: Image.asset('images/admin.png', width: 300, height: 100),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Admin",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Form(
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.person,
                    controller: _adminIdlInput,
                    hintText: "ID",
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
                _adminIdlInput.text.isNotEmpty && _passwordInput.text.isNotEmpty
                    ? _loginAdmin()
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
              height: 20.0,
            ),
            FlatButton.icon(
              color: Colors.black,
              label: Text(
                "i'm not Admin ",
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
                  builder: (context) => AuthenticScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _loginAdmin() {
    Firestore.instance.collection("admins").getDocuments().then((snapshot) {
      snapshot.documents.forEach((result) {
        if (result.data['id'] != _adminIdlInput.text.trim()) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Youre id not currect"),
          ));
        } else if (result.data['password'] != _passwordInput.text.trim()) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Youre password not currect"),
          ));
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Welcome Admin ${result.data['name']}"),
          ));
          setState(() {
            _adminIdlInput.text = '';
            _passwordInput.text = '';
          });
          Route route = MaterialPageRoute(builder: (c) => UploadPage());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }
}
