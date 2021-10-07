import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverpodWithVisibility extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageView(
        children: [
          _View1(),
          _View2(),
          _View3(),
          _View4(),
        ],
      ),
    );
  }
}

List<Widget> _createFooterWidgets(int number) {
  return [
    Center(
      child: Card(
        child: Text(
          "I am footer $number.",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  ];
}

class _View1 extends StatefulWidget {
  @override
  _View1State createState() => _View1State();
}

class _View1State extends State<_View1> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final footer = _visible ? _createFooterWidgets(1) : null;
    return Scaffold(
      appBar: AppBar(title: Text("Visibility sample")),
      body: Center(
        child: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => setState(() => _visible = !_visible),
        ),
      ),
      persistentFooterButtons: footer,
    );
  }
}

class _View2 extends ConsumerWidget {
  final StateProvider<bool> _provider = StateProvider((ref) => false);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(title: Text("Visibility sample2")),
      body: Center(
        child: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () =>
              context.read(_provider).state = !context.read(_provider).state,
        ),
      ),
      persistentFooterButtons: [
        Visibility(
          child: _createFooterWidgets(2).first,
          visible: watch(_provider).state,
        )
      ],
    );
  }
}

final _visibleProvider = StateProvider((ref) => false);
final _footerProvider = StateProvider<List<Widget>?>((ref) {
  final visible = ref.watch(_visibleProvider).state;
  return visible ? _createFooterWidgets(3) : null;
});

class _View3 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(title: Text("Visibility sample3")),
      body: Center(
        child: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => context.read(_visibleProvider).state =
              !context.read(_visibleProvider).state,
        ),
      ),
      persistentFooterButtons: watch(_footerProvider).state,
    );
  }
}

class _View4 extends ConsumerWidget {
  final StateProvider<bool> _provider = StateProvider((ref) => false);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final visible = watch(_provider).state;
    return Scaffold(
      appBar: AppBar(title: Text("Visibility sample4")),
      body: Center(
        child: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () =>
              context.read(_provider).state = !context.read(_provider).state,
        ),
      ),
      persistentFooterButtons: visible ? _createFooterWidgets(4) : null,
    );
  }
}
