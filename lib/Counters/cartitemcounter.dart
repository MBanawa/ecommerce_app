import 'package:ecommerce_app/Config/config.dart';
import 'package:flutter/foundation.dart';

class CartItemCounter with ChangeNotifier {
  int _counter = EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList)
          .length -
      1;
  int get count => _counter;
}
