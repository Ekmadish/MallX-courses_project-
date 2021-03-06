import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:malX/Config/config.dart';

class CartItemCounter extends ChangeNotifier {
  int _counter = EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList)
          .length -
      1;
  int get count => _counter;
  Future<Void> displayResult() async {
    int _counter = EcommerceApp.sharedPreferences
            .getStringList(EcommerceApp.userCartList)
            .length -
        1;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
      // return _counter;
    });
  }
}
