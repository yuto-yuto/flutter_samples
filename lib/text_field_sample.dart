import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_samples/custom_widgets/labeled_divider.dart';

class TextFieldSample extends StatefulWidget {
  const TextFieldSample({Key? key}) : super(key: key);

  @override
  _TextFieldSampleState createState() => _TextFieldSampleState();
}

class _TextFieldSampleState extends State<TextFieldSample> {
  String _inputText = "";
  String? _errorText = null;

  FocusNode _focusNode = FocusNode();
  Color _filledColor = Colors.white;

  @override
  void initState() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _filledColor = Colors.blue.shade100;
        });
      } else {
        setState(() {
          _filledColor = Colors.white;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TextField Sample"),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          TextField(),
          LabeledDivider("Label related"),
          ..._label(),
          SizedBox(height: 20),
          LabeledDivider("Decoration related"),
          ..._decoration(),
          SizedBox(height: 20),
          LabeledDivider("With Icon"),
          ..._withIcon(),
          SizedBox(height: 20),
          LabeledDivider("Input related"),
          ..._inputRelated(),
          LabeledDivider("Enter behavior"),
          SizedBox(height: 20),
          ..._enterBehavior(),
        ],
      ),
    );
  }

  List<Widget> _label() {
    return [
      TextField(
        decoration: InputDecoration(
          labelText: "Label name",
        ),
      ),
      SizedBox(height: 20),
      TextField(
        decoration: InputDecoration(
          labelText: "Label center",
          floatingLabelAlignment: FloatingLabelAlignment.center,
        ),
      ),
      SizedBox(height: 20),
      TextField(
        decoration: InputDecoration(
          labelText: "Label name",
          labelStyle: TextStyle(fontSize: 20, color: Colors.purple),
          floatingLabelAlignment: FloatingLabelAlignment.center,
        ),
      ),
      SizedBox(height: 20),
      TextField(
        decoration: InputDecoration(
          floatingLabelAlignment: FloatingLabelAlignment.center,
          labelText: "Label and Hint text",
          hintText: "hint text",
        ),
      ),
      SizedBox(height: 20),
      TextField(
        decoration: InputDecoration(
          floatingLabelAlignment: FloatingLabelAlignment.center,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: "Always show Hint and Label",
          hintText: "hint text",
        ),
      ),
      SizedBox(height: 20),
      TextField(
        decoration: InputDecoration(
          label: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Icon(Icons.house),
            Icon(Icons.watch),
            Icon(Icons.wallet),
            Text("Label"),
          ]),
        ),
      ),
      SizedBox(height: 20),
      TextField(
        onChanged: (value) => setState(() {
          _inputText = value;
        }),
        decoration: InputDecoration(
          labelText: "Label for Preffix and Suffix",
          hintText: "input something here",
          prefixText: "preffix_",
          suffixText: "_suffix",
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.black),
          ),
        ),
      ),
      Center(
        child: Text("Input text: $_inputText"),
      ),
    ];
  }

  List<Widget> _decoration() {
    return [
      TextField(
        decoration: InputDecoration(
          floatingLabelAlignment: FloatingLabelAlignment.center,
          label: Text("Without border"),
          border: InputBorder.none,
        ),
      ),
      SizedBox(height: 20),
      TextField(
        decoration: InputDecoration(
          floatingLabelAlignment: FloatingLabelAlignment.center,
          label: Text("Without border but on focus"),
          border: InputBorder.none,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.black),
          ),
        ),
      ),
      SizedBox(height: 20),
      TextField(
        decoration: InputDecoration(
          floatingLabelAlignment: FloatingLabelAlignment.center,
          label: Text("Circular border"),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 5, color: Colors.black), // ignored...
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
        ),
      ),
      SizedBox(height: 20),
      TextField(
        decoration: InputDecoration(
          floatingLabelAlignment: FloatingLabelAlignment.center,
          label: Text("Boder change when focused"),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 4, color: Colors.green),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 6, color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
        ),
      ),
      SizedBox(height: 20),
      TextField(
        focusNode: _focusNode,
        decoration: InputDecoration(
          floatingLabelAlignment: FloatingLabelAlignment.center,
          label: Text(
            "Fill color on focus",
            style: TextStyle(fontSize: 28),
          ),
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: _filledColor,
        ),
      ),
    ];
  }

  List<Widget> _withIcon() {
    return [
      SizedBox(height: 20),
      TextField(
        decoration: InputDecoration(
          icon: Icon(Icons.search),
          iconColor: Colors.green,
          hintText: "Search...",
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.black),
          ),
        ),
      ),
      SizedBox(height: 20),
      TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          prefixIconColor: Colors.red,
          hintText: "Search...",
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.black),
          ),
        ),
      ),
      SizedBox(height: 20),
      TextField(
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.search),
          suffixIconColor: Colors.purpleAccent,
          hintText: "Search...",
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.black),
          ),
        ),
      ),
    ];
  }

  List<Widget> _inputRelated() {
    return [
      SizedBox(height: 20),
      TextField(
        maxLength: 5,
        decoration: InputDecoration(
          label: Text("Hint text"),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: "Always show hint text",
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.black),
          ),
        ),
      ),
      SizedBox(height: 20),
      TextField(
        maxLength: 5,
        decoration: InputDecoration(
          label: Text("Set maxLength with counter"),
          hintText: "Input something",
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.black),
          ),
        ),
      ),
      SizedBox(height: 20),
      TextField(
        maxLength: 5,
        decoration: InputDecoration(
          label: Text("Set maxLength without counter"),
          hintText: "Input something",
          counterText: "",
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.black),
          ),
        ),
      ),
      SizedBox(height: 20),
      TextField(
        obscureText: true,
        maxLength: 10,
        decoration: InputDecoration(
          label: Text("Password"),
          hintText: "Input your password",
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.black),
          ),
        ),
      ),
      SizedBox(height: 20),
      TextField(
        maxLength: 10,
        onChanged: (value) {
          // Requirement
          // at least one lower case
          // at least one upper case
          // at least one number
          // at least one special character
          // length must be 5 or bigger
          final regex = RegExp("^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%&*]).{5,}");

          if (!value.isEmpty && !regex.hasMatch(value)) {
            setState(() {
              _errorText = "invalid password";
            });
          } else {
            setState(() {
              _errorText = null;
            });
          }
        },
        decoration: InputDecoration(
          label: Text("Password"),
          hintText: "Input your password",
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.black),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: Colors.red),
          ),
          errorText: _errorText,
        ),
      ),
      SizedBox(height: 20),
      TextField(
        maxLength: 19, // 4 * 4 + 3 spaces
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          CardNumberFormatter(),
        ],
        onChanged: (value) {},
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.credit_card),
          labelText: "Credit Card Number",
          hintText: "XXXX XXXX XXXX XXXX",
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.black),
          ),
        ),
      ),
      SizedBox(height: 20),
      TextField(
        textInputAction: TextInputAction.newline,
        maxLines: null,
        decoration: InputDecoration(
          labelText: "Multilines",
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.black),
          ),
        ),
      ),
      SizedBox(height: 20),
      TextField(
        keyboardType: TextInputType.multiline,
        maxLines: 3, // display only for 3 lines but not limit the number of lines
        decoration: InputDecoration(
          labelText: "Max 3 lines",
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.black),
          ),
        ),
      ),
    ];
  }

  List<Widget> _enterBehavior() {
    return [
      Row(
        children: [
          Flexible(
            flex: 1,
            child: TextField(
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: "Input A",
                border: const OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.black),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(right: 5, left: 5),
              child: TextField(
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Input B",
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: TextField(
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: "Input C",
                border: const OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    ];
  }
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue previousValue,
    TextEditingValue nextValue,
  ) {
    String result = "";

    for (int i = 0; i < nextValue.text.length; i++) {
      result += nextValue.text[i];
      final indexFromOne = i + 1;
      if (indexFromOne % 4 == 0 && indexFromOne != nextValue.text.length) {
        result += " ";
      }
    }

    return nextValue.copyWith(
      text: result,
      selection: TextSelection.collapsed(
        offset: result.length,
      ),
    );
  }
}
