import 'package:flutter/foundation.dart';

class ItemQuantity with ChangeNotifier {
  int _numberOfItems = 0;

  int get numberOfItems => _numberOfItems;

  display(int no) {
    _numberOfItems = no;
    notifyListeners();
  }
}
