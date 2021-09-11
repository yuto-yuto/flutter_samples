import 'package:flutter/material.dart';
import 'package:flutter_samples/DynamicTextField.dart';
import 'package:flutter_samples/ScaffoldFooterView.dart';
import 'package:flutter_samples/grouped_extension_tile_sample.dart';

void main() {
  runApp(MaterialApp(
    title: "App",
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _createButton(Widget view) {
      return TextButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => view),
          );
        },
        child: Text(
          view.toString(),
          textScaleFactor: 2,
        ),
      );
    }

    final listView = ListView(
      children: [
        _createButton(ScaffoldFooterView()),
        _createButton(DynamicTextFieldView()),
        _createButton(GroupedExtensionTileSample()),
      ],
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Flutter Samples"),
        ),
        body: listView,
      ),
    );
  }
}
