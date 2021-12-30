import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropdownSample extends StatefulWidget {
  @override
  _DropDownSample createState() => _DropDownSample();
}

class _DropDownSample extends State<DropdownSample> {
  final list = ["Apple", "Orange", "Kiwi", "Banana", "Grape"];
  List<DropdownMenuItem<String>> _createList() {
    return list
        .map<DropdownMenuItem<String>>(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(e),
          ),
        )
        .toList();
  }

  String? _selectedItem1;
  Widget _onChangedWithoutValue() {
    final dropdown = DropdownButton(
      items: _createList(),
      onChanged: (String? value) => setState(() {
        _selectedItem1 = value ?? "";
      }),
    );
    return _createDropdownContainer(
      dropdown,
      "Notify Value change \n without value",
      _selectedItem1,
    );
  }

  String? _selectedItem2;
  Widget _onChangedWithValue() {
    final dropdown = DropdownButton(
      items: _createList(),
      value: _selectedItem2,
      onChanged: (String? value) => setState(() {
        _selectedItem2 = value ?? "";
      }),
    );
    return _createDropdownContainer(
      dropdown,
      "Notify Value change \n with value",
      _selectedItem2,
    );
  }

  String? _selectedItem3;
  Widget _withHint() {
    final dropdown = DropdownButton(
      items: _createList(),
      hint: Text("Choose an item"),
      value: _selectedItem3,
      onChanged: (String? value) => setState(() {
        _selectedItem3 = value ?? "";
      }),
    );
    return _createDropdownContainer(
      dropdown,
      "With Hint",
      _selectedItem3,
    );
  }

  String _selectedItem4 = "Orange";
  Widget _initialValue() {
    final dropdown = DropdownButton(
      items: _createList(),
      hint: Text("Choose an item"),
      value: _selectedItem4,
      onChanged: (String? value) => setState(() {
        _selectedItem4 = value ?? "";
      }),
    );
    return _createDropdownContainer(
      dropdown,
      "Initial value",
      _selectedItem4,
    );
  }

  Widget _disableHint() {
    final dropdown = DropdownButton(
      items: _createList(),
      disabledHint: Text("Disable Hint"),
      onChanged: null,
    );
    return _createDropdownContainer(
      dropdown,
      "Disable Hint",
      "",
    );
  }

  String? _selectedItem5;
  bool _enable = true;
  String _buttonText = "disable";
  Widget _disable() {
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
    final dropdown = DropdownButton(
      value: _selectedItem5,
      items: _createList(),
      disabledHint: Text("Disable Hint"),
      onChanged: _enable ? onChanged : null,
    );
    return _createDropdownContainer(
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
    final onlyItems = DropdownButton(
      items: _createList(),
      onChanged: null,
    );
    final backColor = DropdownButton(
      items: _createList(),
      onChanged: (value) {},
      dropdownColor: Colors.cyan,
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Dropdown Sample"),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _addLabelTo(onlyItems, "Only Items"),
                _onChangedWithoutValue(),
                _onChangedWithValue(),
                _initialValue(),
                _withHint(),
                _disableHint(),
                _disable(),
                _addLabelTo(backColor, "Change back color"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _addLabelTo(Widget child, String text) {
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

  Widget _createDropdownContainer(
      Widget dropdown, String label, String? value) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Column(
        children: [
          _addLabelTo(dropdown, label),
          Padding(
            child: Text("selected item: $value"),
            padding: EdgeInsetsDirectional.only(top: 10, bottom: 10),
          ),
        ],
      ),
    );
  }
}
