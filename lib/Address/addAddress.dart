import 'package:flutter/material.dart';
import 'package:malX/Config/config.dart';
import 'package:malX/Models/address.dart';
import 'package:malX/Widgets/customAppBar.dart';

class AddAddress extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final scafflodKey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cPhoneNomber = TextEditingController();
  final cFlatHomeNomber = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cPinCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scafflodKey,
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            //save user Adderss info DB
            if (formKey.currentState.validate()) {
              final model = AddressModel(
                name: cName.text,
                state: cState.text.trim(),
                pincode: cPinCode.text,
                phoneNumber: cPhoneNomber.text,
                flatNumber: cFlatHomeNomber.text,
                city: cCity.text.trim(),
              ).toJson();

              EcommerceApp.firestore
                  .collection(EcommerceApp.collectionUser)
                  .document(EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userUID))
                  .collection(EcommerceApp.subCollectionAddress)
                  .document(DateTime.now().millisecondsSinceEpoch.toString())
                  .setData(model)
                  .then((value) {
                final snackbar = SnackBar(
                    backgroundColor: Colors.blueAccent,
                    content: Text("New Address added successfully"));

                scafflodKey.currentState.showSnackBar(snackbar);
                FocusScope.of(context).requestFocus(FocusNode());

                formKey.currentState.reset();
              });
            }
          },
          label: Text("Done"),
          backgroundColor: Colors.black45,
          icon: Icon(Icons.check),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Add New Address",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Form(
                child: Column(
                  children: [
                    //
                    MyTextField(
                      hint: "Name",
                      controller: cName,
                    ),
                    MyTextField(
                      hint: "Phone Number",
                      controller: cPhoneNomber,
                    ),
                    MyTextField(
                      hint: "Flat Number / House Number",
                      controller: cFlatHomeNomber,
                    ),
                    MyTextField(
                      hint: "City",
                      controller: cCity,
                    ),
                    MyTextField(
                      hint: "Country",
                      controller: cState,
                    ),
                    MyTextField(
                      hint: "PinCode",
                      controller: cPinCode,
                    ),
                  ],
                ),
                key: formKey,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;

  const MyTextField({Key key, this.hint, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (val) => val.isEmpty ? "Field can not be empty ." : null,
      ),
    );
  }
}
