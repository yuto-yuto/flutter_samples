import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DynamicTextFieldView extends StatefulWidget {
  @override
  _DynamicTextFieldView createState() => _DynamicTextFieldView();
}

class _DynamicTextFieldView extends State<DynamicTextFieldView> {
  List<TextEditingController> _controllers = [];
  List<TextField> _fields = [];
  Map<String, TextEditingController> _controllerMap = Map();

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _controllerMap.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageView(
        children: [
          _view1(),
          _view2(),
        ],
      ),
    );
  }

  Widget _view1() {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Dynamic Text Field"),
          ),
          body: Column(
            children: [
              _addTile(),
              Expanded(child: _listView()),
              _okButton(),
            ],
          )),
    );
  }

  Widget _addTile() {
    return ListTile(
      title: Icon(Icons.add),
      onTap: () {
        final controller = TextEditingController();
        final field = TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "name${_controllers.length + 1}",
          ),
        );

        setState(() {
          _controllers.add(controller);
          _fields.add(field);
        });
      },
    );
  }

  Widget _listView() {
    return ListView.builder(
      itemCount: _fields.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(5),
          child: _fields[index],
        );
      },
    );
  }

  Widget _okButton() {
    return ElevatedButton(
      onPressed: () async {
        String text =
            _controllers.fold("", (acc, element) => acc += "${element.text}\n");
        final alert = AlertDialog(
          title: Text("Count: ${_controllers.length}"),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
        await showDialog(
          context: context,
          builder: (BuildContext context) => alert,
        );
        setState(() {});
      },
      child: Text("OK"),
    );
  }

  // for view2
  Widget _view2() {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Dynamic Text Field with async"),
          ),
          body: Column(
            children: [
              Expanded(child: _futureBuilder()),
              _okButton2(),
            ],
          )),
    );
  }

  Future<List<String>> _retrieveData() {
    return Future.value([
      "one",
      "two",
      "three",
      "four",
    ]);
  }

  Widget _okButton2() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              _controllerMap.forEach((key, controller) {
                controller.text = key;
              });
            });
          },
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _controllerMap.forEach((key, controller) {
                key = controller.text;
              });
            });
          },
          child: Text("OK"),
        ),
      ],
    );
  }

  Widget _futureBuilder() {
    return FutureBuilder(
      future: _retrieveData(),
      builder: (BuildContext context, AsyncSnapshot<List<String>?> snapshot) {
        if (!snapshot.hasData) {
          return Align(
            alignment: Alignment.topCenter,
            child: Text("No item"),
          );
        }

        final data = snapshot.data!;
        return ListView.builder(
          itemCount: data.length,
          padding: EdgeInsets.all(5),
          itemBuilder: (BuildContext context, int index) {
            final controller = _getControllerOf(data[index]);

            final textField = TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "name${index + 1}",
              ),
            );
            return Container(
              child: textField,
              padding: EdgeInsets.only(bottom: 10),
            );
          },
        );
      },
    );
  }

  TextEditingController _getControllerOf(String name) {
    var controller = _controllerMap[name];
    if (controller == null) {
      controller = TextEditingController(text: name);
      _controllerMap[name] = controller;
    }
    return controller;
  }
}
