import 'package:ecommerce_app/Widgets/loadingWidget.dart';
import 'package:flutter/material.dart';

class LoadinAlertDialog extends StatelessWidget {
  final String message;
  const LoadinAlertDialog({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circularProgress(),
          SizedBox(
            height: 10.0,
          ),
          Text(message),
        ],
      ),
    );
  }
}
