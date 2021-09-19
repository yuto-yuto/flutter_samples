import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Notifier<T> extends ChangeNotifier {
  T _value;
  Notifier(this._value);

  set value(T value) {
    if (_value == value) {
      return;
    }
    _value = value;
    notifyListeners();
  }

  T get value => _value;
}

class ProviderSample extends StatefulWidget {
  @override
  _ProviderSample createState() => _ProviderSample();
}

class _ProviderSample extends State<ProviderSample> {
  int count = 0;
  final Notifier<int> _countNotifier = Notifier<int>(0);

  @override
  Widget build(BuildContext context) {
    final childrenWidgets = [
      Expanded(child: _buildColumn1()),
      Expanded(child: _buildColumn2()),
    ];

    final parent = Column(
      children: [
        TextButton(
          onPressed: () => setState(() => count++),
          child: Text(
            "Refresh parent",
            textScaleFactor: 2,
          ),
        ),
        Container(
          height: 100,
          width: 300,
          child: Text(
            "refresh count: $count",
            textScaleFactor: 1.3,
          ),
        )
      ],
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Provier sample"),
        ),
        body: Column(
          children: [
            Row(children: childrenWidgets),
            Center(child: parent),
          ],
        ),
      ),
    );
  }

  Widget _buildColumn1() {
    final button = ElevatedButton(
      onPressed: () {
        _countNotifier.value++;
      },
      child: Icon(Icons.add),
    );

    final column = Column(
      children: [
        button,
        Box1(),
      ],
    );

    return ChangeNotifierProvider.value(
      value: _countNotifier,
      child: column,
    );
  }

  Widget _buildColumn2() {
    return ChangeNotifierProvider(
      create: (context) => _ParamsNotifier(),
      child: Column(
        children: [
          ButtonForBox2Counter(),
          ButtonForBox2Color(),
          Box2(),
        ],
      ),
    );
  }
}

class _ParamsNotifier extends ChangeNotifier {
  Color _color = Colors.black;
  int _count = 0;

  Color get color => _color;
  set color(Color value) {
    if (_color == value) {
      return;
    }
    _color = value;
    notifyListeners();
  }

  int get count => _count;
  set count(int value) {
    if (_count == value) {
      return;
    }
    _count = value;
    notifyListeners();
  }
}

class Box1 extends StatelessWidget {
  static int _rebuildCount = 0;
  @override
  Widget build(BuildContext context) {
    _rebuildCount++;
    return Consumer<Notifier<int>>(
      builder: (context, count, child) => Container(
        height: 100,
        width: 150,
        child: Center(
          child: Text('Rebuild: $_rebuildCount\n'
              '${count.value.toString()}'),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue,
            width: 5,
          ),
        ),
      ),
    );
  }
}

class ButtonForBox2Counter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<_ParamsNotifier>(
      builder: (context, params, child) => ElevatedButton(
        onPressed: () {
          params.count++;
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ButtonForBox2Color extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<_ParamsNotifier>(
      builder: (context, params, child) => ElevatedButton(
        onPressed: () {
          if (params.color == Colors.black) {
            params.color = Colors.red;
          } else {
            params.color = Colors.black;
          }
        },
        child: Icon(Icons.change_circle),
      ),
    );
  }
}

class Box2 extends StatelessWidget {
  static int _rebuildCount = 0;
  @override
  Widget build(BuildContext context) {
    _rebuildCount++;
    return Consumer<_ParamsNotifier>(
      builder: (context, params, child) => Container(
        height: 100,
        width: 150,
        child: Center(
          child: Text('Rebuild: $_rebuildCount\n'
              '${params.count.toString()}'),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: params.color,
            width: 5,
          ),
        ),
      ),
    );
  }
}
