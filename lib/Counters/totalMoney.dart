import 'package:flutter/cupertino.dart';

class TotalAmount extends ChangeNotifier {
  double _totalAmout = 0;

  double get totalAmount => _totalAmout;
  displayResult(double no) async {
    _totalAmout = no;
    await Future.delayed(
      const Duration(milliseconds: 100),
      () {
        notifyListeners();
      },
    );
  }
}
