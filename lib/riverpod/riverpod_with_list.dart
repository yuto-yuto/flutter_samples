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
          _View2(),
        ],
      ),
    );
  }
}

class _View1 extends ConsumerWidget {
  final List<String> _texts = [];
  final StateProvider<int> _lengthProvider = StateProvider((ref) => 0);

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
        return ListTile(
          title: Text(_texts[index] + "/${_texts.length}"),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text("List with StateProvider")),
      body: Column(children: [
        Center(child: button),
        Expanded(child: listView),
      ]),
    );
  }
}

class _View2 extends ConsumerWidget {
  final List<String> _texts = [];
  final StateProvider<int> _lengthProvider = StateProvider((ref) => 0);
  final List<StateProvider<int>> _countProviderList = [];

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final button = IconButton(
      onPressed: () {
        _texts.add("string-${_texts.length + 1}");
        _countProviderList.add(StateProvider((ref) => 0));
        context.read(_lengthProvider).state = _texts.length;
      },
      icon: Icon(Icons.add),
    );

    final listView = ListView.builder(
      itemCount: watch(_lengthProvider).state,
      itemBuilder: (context, index) {
        final text = _texts[index] +
            "/${_texts.length}" +
            "\t${watch(_countProviderList[index]).state.toString()}";
        return ListTile(
          title: Text(text),
          onTap: () => context.read(_countProviderList[index]).state++,
        );
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text("List with StateProvider2")),
      body: Column(children: [
        Center(child: button),
        Expanded(child: listView),
      ]),
    );
  }
}
