import 'package:flutter/foundation.dart';

class BookQuantity with ChangeNotifier {
  int _numberofItems = 0;

  int get numberOfItems => _numberofItems;

  diplay(int nom) {
    _numberofItems = nom;
    notifyListeners();
  }
}
