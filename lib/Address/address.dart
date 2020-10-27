import 'package:flutter/material.dart';

class Address extends StatefulWidget {
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(),
    );
  }

  noAddressCard() {
    return Card();
  }
}

class AddressCard extends StatefulWidget {
  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell();
  }
}

class KeyText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '',
    );
  }
}
