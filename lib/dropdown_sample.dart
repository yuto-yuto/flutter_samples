import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropdownSample extends StatefulWidget {
  @override
  _DropDownSample createState() => _DropDownSample();
}

class _DropDownSample extends State<DropdownSample> {
  String? _selectedItem1;
  Widget onChangedWithoutValue() {
    final dropdown = createDropdown(
      onChanged: (value) => setState(() {
        _selectedItem1 = value ?? "";
      }),
    );
    return createDropdownContainer(
      dropdown,
      "Notify Value change \n without value",
      _selectedItem1,
    );
  }

  String? _selectedItem2;
  Widget onChangedWithValue() {
    final dropdown = createDropdown(
      value: _selectedItem2,
      onChanged: (value) => setState(() {
        _selectedItem2 = value ?? "";
      }),
    );
    return createDropdownContainer(
      dropdown,
      "Notify Value change \n with value",
      _selectedItem2,
    );
  }

  String? _selectedItem3;
  Widget withHint() {
    final dropdown = createDropdown(
      hint: Text("Choose an item"),
      value: _selectedItem3,
      onChanged: (value) => setState(() {
        _selectedItem3 = value ?? "";
      }),
    );
    return createDropdownContainer(
      dropdown,
      "With Hint",
      _selectedItem3,
    );
  }

  String _selectedItem4 = "Orange";
  Widget initialValue() {
    final dropdown = createDropdown(
      hint: Text("Choose an item"),
      value: _selectedItem4,
      onChanged: (value) => setState(() {
        _selectedItem4 = value ?? "";
      }),
    );
    return createDropdownContainer(
      dropdown,
      "Initial value",
      _selectedItem4,
    );
  }

  Widget disableHint() {
    final dropdown = createDropdown(
      disabledHint: Text("Disable Hint"),
    );
    return createDropdownContainer(
      dropdown,
      "Disable Hint",
      _selectedItem4,
    );
  }

  String _selectedItem5 = "";
  bool _enable = true;
  String _buttonText = "disable";
  Widget disable() {
    final onChanged = (value) => setState(() {
          _selectedItem5 = value ?? "";
        });
    final disableButton = ElevatedButton(
      onPressed: () => setState(() {
        if (_enable) {
          _enable = false;
          _buttonText = "enable";
        } else {
          _enable = true;
          _buttonText = "disable";
        }
      }),
      child: Text(_buttonText),
    );
    final dropdown = createDropdown(
      disabledHint: Text("Disable Hint"),
      onChanged: _enable ? onChanged : null,
    );
    return createDropdownContainer(
      Column(children: [
        Center(child: disableButton),
        dropdown,
      ]),
      "Disable Hint",
      _selectedItem5,
    );
  }

  @override
  Widget build(BuildContext context) {
    final onlyItems = createDropdown();
    final backColor =
        createDropdown(onChanged: (value) {}, dropdownColor: Colors.cyan);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Dropdown Sample"),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                addLabelTo(onlyItems, "Only Items"),
                onChangedWithoutValue(),
                onChangedWithValue(),
                initialValue(),
                withHint(),
                disableHint(),
                disable(),
                addLabelTo(backColor, "Change back color"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget createResultArea(String? value) {
    return Padding(
      child: Text("selected item: $value"),
      padding: EdgeInsetsDirectional.only(top: 30),
    );
  }

  Widget createDropdown({
    String? value,
    Widget? hint,
    void Function(String?)? onChanged,
    Color? dropdownColor,
    Widget? disabledHint,
  }) {
    const list = ["Apple", "Orange", "Kiwi", "Banana", "Grape"];

    return DropdownButton(
      value: value,
      hint: hint,
      onChanged: onChanged,
      dropdownColor: dropdownColor,
      disabledHint: disabledHint,
      items: list
          .map<DropdownMenuItem<String>>(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
    );
  }

  Widget addLabelTo(Widget child, String text) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(flex: 2, child: Center(child: child)),
      ],
    );
  }

  Widget createDropdownContainer(Widget dropdown, String label, String? value) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Column(
        children: [
          addLabelTo(dropdown, label),
          Padding(
            child: Text("selected item: $value"),
            padding: EdgeInsetsDirectional.only(top: 10, bottom: 10),
          ),
        ],
      ),
    );
  }
}
