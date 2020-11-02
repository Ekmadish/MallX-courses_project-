import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AdminOrderDetails extends StatelessWidget {
  final orderID;
  final orderby;
  final addressID;

  const AdminOrderDetails({Key key, this.orderID, this.orderby, this.addressID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea();
  }
}

class StatusBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PaymentDetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ShippingDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column();
  }
}

class KeyText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("");
  }
}
