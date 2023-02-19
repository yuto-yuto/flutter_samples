import 'package:flutter/material.dart';

class KeyDetectionOnTable extends StatefulWidget {
  const KeyDetectionOnTable({Key? key}) : super(key: key);

  @override
  _KeyDetectionOnTableState createState() => _KeyDetectionOnTableState();
}

class _KeyDetectionOnTableState extends State<KeyDetectionOnTable> {
  final focusNodeForCheckBox = FocusNode();
  final controller = TextEditingController();
  bool isChecked = false;
  String text = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Key Detection On Data Table"),
        ),
        body: Column(children: [
          _generateListenerAndCheckBox(),
        ]),
      ),
    );
  }

  Widget _generateListenerAndCheckBox() {
    final checkBoxAndListener = _generateContainer(
      child: KeyboardListener(
        focusNode: focusNodeForCheckBox,
        onKeyEvent: (event) {
          // debugPrint(event.toString());
          setState(() {
            text = event.logicalKey.keyLabel;
          });
        },
        child: Checkbox(
          value: isChecked,
          onChanged: (value) {
            setState(() => isChecked = !focusNodeForCheckBox.hasFocus);
            if (!focusNodeForCheckBox.hasFocus) {
              focusNodeForCheckBox.requestFocus();
            } else {
              focusNodeForCheckBox.nextFocus();
            }
          },
        ),
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        checkBoxAndListener,
        _generateContainer(
          child: Text(text),
        ),
      ],
    );
  }

  Widget _generateContainer({required Widget child}) {
    return Container(
      height: 100,
      width: 200,
      child: child,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 3),
        color: Colors.blue.shade50,
      ),
    );
  }
}
