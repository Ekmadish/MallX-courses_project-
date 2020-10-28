import 'package:flutter/material.dart';
import 'package:malX/Counters/changeAddresss.dart';
import 'package:malX/Counters/totalMoney.dart';
import 'package:malX/Models/address.dart';
import 'package:malX/Orders/placeOrder.dart';
import 'package:malX/Widgets/customAppBar.dart';
import 'package:malX/Widgets/wideButton.dart';
import 'package:provider/provider.dart';

import 'addAddress.dart';

class Address extends StatefulWidget {
  final double totalAmount;

  const Address({Key key, this.totalAmount}) : super(key: key);

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddAddress()),
            );
          },
          label: Text("Add new Address"),
          backgroundColor: Colors.green,
          icon: Icon(Icons.add_location),
        ),
      ),
    );
  }

  noAddressCard() {
    return Card();
  }
}

class AddressCard extends StatefulWidget {
  final AddressModel model;
  final int currentIndex;
  final int value;
  final String addressId;
  final double totalAmount;

  const AddressCard(
      {Key key,
      this.model,
      this.currentIndex,
      this.value,
      this.addressId,
      this.totalAmount})
      : super(key: key);
  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      child: Card(
        color: Colors.green,
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  activeColor: Colors.blueGrey,
                  value: widget.value,
                  groupValue: widget.currentIndex,
                  onChanged: (val) {
                    Provider.of<AddressChanger>(context, listen: false)
                        .displayResult(val);
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      width: screenWidth * 0.8,
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              KeyText(
                                msg: "Name",
                              ),
                              Text(widget.model.name),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(
                                msg: "Phone nomber",
                              ),
                              Text(widget.model.phoneNumber),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(
                                msg: "House Nomber",
                              ),
                              Text(widget.model.flatNumber),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(
                                msg: "City",
                              ),
                              Text(widget.model.city),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(
                                msg: "State",
                              ),
                              Text(widget.model.state),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(
                                msg: "PinCode",
                              ),
                              Text(widget.model.pincode),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            widget.value == Provider.of<AddressChanger>(context).count
                ? WideButton(
                    message: "Proceed",
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (c) => PaymentPage(addressId:widget.addressId,
                          totalAmount:widget.totalAmount,
                          )));
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class KeyText extends StatelessWidget {
  final String msg;

  const KeyText({Key key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      msg,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    );
  }
}
