import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_samples/dynamic_text_field.dart';
import 'package:flutter_samples/ScaffoldFooterView.dart';
import 'package:flutter_samples/draggable_sample.dart';
import 'package:flutter_samples/grouped_expansion_tile_sample.dart';
import 'package:flutter_samples/provider_sample.dart';
import 'package:flutter_samples/riverpod/dynamic_textfield_with_riverpod.dart';
import 'package:flutter_samples/riverpod/multi_providers.dart';
import 'package:flutter_samples/riverpod/riverpod-with-visibility.dart';
import 'package:flutter_samples/riverpod/riverpod_with_list.dart';
import 'package:flutter_samples/scrollable_draggable.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: "App",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyApp(),
      ),
    ),
  );
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
          textScaleFactor: 1.5,
        ),
      );
    }

    final listView = ListView(
      children: [
        _createButton(ScaffoldFooterView()),
        _createButton(DynamicTextFieldView()),
        _createButton(GroupedExpansionTileSample()),
        _createButton(DraggableSample()),
        _createButton(ProviderSample()),
        _createButton(ScrollableDraggable()),
        _createButton(RiverpodWithList()),
        _createButton(RiverpodWithVisibility()),
        _createButton(DynamicTextFieldWithRiverpod()),
        _createButton(MultiProviders()),
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
