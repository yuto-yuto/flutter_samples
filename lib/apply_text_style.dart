import 'package:flutter/material.dart';

class _MyTextStyle {
  static final style1 = TextStyle(
    fontSize: 40,
    color: Colors.red,
    fontStyle: FontStyle.italic,
  );
}

class ApplyTextStyle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Apply Text Style"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _children(),
              SizedBox(height: 20),
              DefaultTextStyle.merge(
                style: _MyTextStyle.style1,
                child: _children(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _children() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("AAA"),
            Text("BBB"),
            Text("CCC"),
          ],
        ),
        ListTile(title: Text("I am ListTile")),
        ListView(
          shrinkWrap: true,
          children: [
            Text("ListView item 1"),
            Text("ListView item 2"),
            Text("ListView item 3"),
          ],
        ),
      ],
    );
  }
}
