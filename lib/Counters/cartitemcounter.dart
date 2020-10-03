import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:malX/Config/config.dart';

class CartItemCounter extends ChangeNotifier {
  int _counter = EcommerceApp.sharedPreferences
          .getString(EcommerceApp.userCartList)
          .length -
      1;
  int get count => _counter;
}
