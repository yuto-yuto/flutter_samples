import 'package:flutter/material.dart';

Widget generateContainer({required Widget child, double? height, double? width}) {
  return Container(
    height: height ?? 100,
    width: width ?? 200,
    child: child,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black, width: 3),
      color: Colors.blue.shade50,
    ),
  );
}

Widget createButtonForPage(BuildContext context, Widget view) {
  return TextButton(
    onPressed: () async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => view),
      );
    },
    child: Text(
      view.toString(),
      textScaleFactor: 1.5,
    ),
  );
}
