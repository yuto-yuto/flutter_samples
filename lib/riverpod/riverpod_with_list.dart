import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverpodWithList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageView(
        children: [
          _View1(),
        ],
      ),
    );
  }
}

class _View1 extends ConsumerWidget {
  final List<String> _texts = [];
  late final StateProvider<int> _lengthProvider = StateProvider((ref) => 0);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final button = IconButton(
      onPressed: () {
        _texts.add("string-${_texts.length + 1}");
        context.read(_lengthProvider).state = _texts.length;
      },
      icon: Icon(Icons.add),
    );

    final listView = ListView.builder(
      itemCount: watch(_lengthProvider).state,
      itemBuilder: (context, index) {
        return Card(child: Text(_texts[index]));
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text("List wth StateProvider")),
      body: Column(children: [
        Center(child: button),
        Expanded(child: listView),
      ]),
    );
  }
}
