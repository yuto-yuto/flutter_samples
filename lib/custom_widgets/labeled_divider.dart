import 'package:flutter/material.dart';

class LabeledDivider extends StatelessWidget {
  final String text;
  const LabeledDivider(this.text);

  @override
  Widget build(BuildContext context) {
    final line = Expanded(
        child: Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Divider(height: 20, thickness: 5),
    ));

    return Row(children: [line, Text(this.text), line]);
  }
}
