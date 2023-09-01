import 'package:flutter/material.dart';

class ToggleSample extends StatefulWidget {
  const ToggleSample({Key? key}) : super(key: key);

  @override
  _ToggleSampleState createState() => _ToggleSampleState();
}

class _ToggleSampleState extends State<ToggleSample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Toggle Sample"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _textToggle(),
          ],
        ),
      ),
    );
  }

  List<bool> _selections = List.generate(2, (index) => false);
  Widget _textToggle() {
    final toggle = LayoutBuilder(
      builder: (context, constraints) {
        return ToggleButtons(
          constraints: BoxConstraints.expand(
            width: constraints.maxWidth / 2 - 5,
          ),
          isSelected: _selections,
          onPressed: (pressedIndex) {
            setState(() {
              _selections = List.generate(2, (index) => index == pressedIndex);
            });
          },
          children: const [
            Text(
              "Icon",
              style: TextStyle(fontSize: 28.0),
            ),
            Text(
              "Text",
              style: TextStyle(fontSize: 28.0),
            ),
          ],
        );
      },
    );

    return Column(
      children: [
        toggle,
        if (_selections[0]) Icon(Icons.alarm) else Text("Alarm"),
      ],
    );
  }
}
