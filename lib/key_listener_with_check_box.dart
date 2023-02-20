import 'common.dart';
import 'package:flutter/material.dart';

class KeyListenerWithCheckBox extends StatefulWidget {
  const KeyListenerWithCheckBox({Key? key}) : super(key: key);

  @override
  _KeyListenerWithCheckBoxState createState() => _KeyListenerWithCheckBoxState();
}

class _KeyListenerWithCheckBoxState extends State<KeyListenerWithCheckBox> {
  final focusNodeForCheckBox = FocusNode();
  bool isChecked = false;
  String text = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Key listener with check box"),
        ),
        body: _generateListenerAndCheckBox(),
      ),
    );
  }

  Widget _generateListenerAndCheckBox() {
    final checkBoxAndListener = generateContainer(
      child: KeyboardListener(
        focusNode: focusNodeForCheckBox,
        onKeyEvent: (event) {
          setState(() {
            text = "logical: ${event.logicalKey.keyLabel}\n" + "physical: ${event.physicalKey.debugName}";
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
        generateContainer(
          child: Center(child: Text(text)),
        ),
      ],
    );
  }
}
