import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showMessage(BuildContext context, String msg, String title) async {
  final alert =  AlertDialog(
    title: Text(title),
    content: Text(msg),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text("OK"),
      ),
    ],
  );
  await showDialog(
    context: context,
    builder: (BuildContext context) => alert,
  );
}