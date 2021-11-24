import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_samples/show_dialog.dart';

class DynamicTextFieldView extends StatelessWidget {
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

class _View1 extends StatefulWidget {
  @override
  _View1State createState() => _View1State();
}

class _View1State extends State<_View1> {
  List<TextEditingController> _controllers = [];
  List<TextField> _fields = [];

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        String text = _controllers
            .where((element) => element.text != "")
            .fold("", (acc, element) => acc += "${element.text}\n");
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
}

class _View2 extends StatefulWidget {
  @override
  _View2State createState() => _View2State();
}

class _View2State extends State<_View2> {
  Map<String, TextEditingController> _controllerMap = Map();

  @override
  void dispose() {
    _controllerMap.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Dynamic Text Field with async"),
          ),
          body: Column(
            children: [
              Expanded(child: _futureBuilder()),
              _cancelOkButton(),
            ],
          )),
    );
  }

  List<String> _data = [
    "one",
    "two",
    "three",
    "four",
  ];
  Future<List<String>> _retrieveData() {
    return Future.value(_data);
  }

  Widget _cancelOkButton() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _cancelButton(),
        _okButton(),
      ],
    );
  }

  Widget _cancelButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _controllerMap.forEach((key, controller) {
            controller.text = key;
          });
        });
      },
      child: Text("Cancel"),
    );
  }

  Widget _okButton() {
    return ElevatedButton(
      onPressed: () async {
        String text = _controllerMap.values
            .where((element) => element.text != "")
            .fold("", (acc, element) => acc += "${element.text}\n");
        await _showUpdatedDialog(text);

        setState(() {
          _controllerMap.forEach((key, controller) {
            int index = _controllerMap.keys.toList().indexOf(key);
            key = controller.text;
            _data[index] = controller.text;
          });
        });
      },
      child: Text("OK"),
    );
  }

  Future _showUpdatedDialog(String text) {
    final alert = AlertDialog(
      title: Text("Updated"),
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
    return showDialog(
      context: context,
      builder: (BuildContext context) => alert,
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

class _View3 extends StatefulWidget {
  @override
  _View3State createState() => _View3State();
}

class _View3State extends State<_View3> {
  List<TextEditingController> _nameControllers = [];
  List<TextField> _nameFields = [];
  List<TextEditingController> _telControllers = [];
  List<TextField> _telFields = [];
  List<TextEditingController> _addressControllers = [];
  List<TextField> _addressFields = [];

  @override
  void dispose() {
    for (final controller in _nameControllers) {
      controller.dispose();
    }
    for (final controller in _telControllers) {
      controller.dispose();
    }
    for (final controller in _addressControllers) {
      controller.dispose();
    }
    _okController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Dynamic Group Text Field"),
          ),
          body: Column(
            children: [
              _addTile(),
              Expanded(child: _listView()),
              _okButton(context),
            ],
          )),
    );
  }

  Widget _addTile() {
    return ListTile(
      title: Icon(Icons.add),
      onTap: () {
        final name = TextEditingController();
        final tel = TextEditingController();
        final address = TextEditingController();

        final nameField = _generateTextField(name, "name");
        final telField = _generateTextField(tel, "mobile");
        final addressField = _generateTextField(address, "address");

        setState(() {
          _nameControllers.add(name);
          _telControllers.add(tel);
          _addressControllers.add(address);
          _nameFields.add(nameField);
          _telFields.add(telField);
          _addressFields.add(addressField);
        });
      },
    );
  }

  TextField _generateTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: hint,
      ),
    );
  }

  Widget _listView() {
    final children = [
      for (var i = 0; i < _nameControllers.length; i++)
        Container(
          margin: EdgeInsets.all(5),
          child: InputDecorator(
            child: Column(
              children: [
                _nameFields[i],
                _telFields[i],
                _addressFields[i],
              ],
            ),
            decoration: InputDecoration(
              labelText: i.toString(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        )
    ];
    return SingleChildScrollView(
      child: Column(
        children: children,
      ),
    );
  }

  final _okController = TextEditingController();
  Widget _okButton(BuildContext context) {
    final textField = TextField(
      controller: _okController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
    );

    final button = ElevatedButton(
      onPressed: () async {
        final index = int.parse(_okController.text);
        String text = "name: ${_nameControllers[index].text}\n" +
            "tel: ${_telControllers[index].text}\n" +
            "address: ${_addressControllers[index].text}";
        await showMessage(context, text, "Result");
      },
      child: Text("OK"),
    );

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          child: textField,
          width: 100,
          height: 50,
        ),
        button,
      ],
    );
  }
}

class _View4 extends StatefulWidget {
  @override
  _View4State createState() => _View4State();
}

class _GroupControllers {
  TextEditingController name = TextEditingController();
  TextEditingController tel = TextEditingController();
  TextEditingController address = TextEditingController();
  void dispose() {
    name.dispose();
    tel.dispose();
    address.dispose();
  }
}

class _View4State extends State<_View4> {
  List<_GroupControllers> _groupControllers = [];
  List<TextField> _nameFields = [];
  List<TextField> _telFields = [];
  List<TextField> _addressFields = [];

  @override
  void dispose() {
    for (final controller in _groupControllers) {
      controller.dispose();
    }
    _okController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Dynamic Group Text Field2"),
          ),
          body: Column(
            children: [
              _addTile(),
              Expanded(child: _listView()),
              _okButton(context),
            ],
          )),
    );
  }

  Widget _addTile() {
    return ListTile(
      title: Icon(Icons.add),
      onTap: () {
        final group = _GroupControllers();

        final nameField = _generateTextField(group.name, "name");
        final telField = _generateTextField(group.tel, "mobile");
        final addressField = _generateTextField(group.address, "address");

        setState(() {
          _groupControllers.add(group);
          _nameFields.add(nameField);
          _telFields.add(telField);
          _addressFields.add(addressField);
        });
      },
    );
  }

  TextField _generateTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: hint,
      ),
    );
  }

  Widget _listView() {
    final children = [
      for (var i = 0; i < _groupControllers.length; i++)
        Container(
          margin: EdgeInsets.all(5),
          child: InputDecorator(
            child: Column(
              children: [
                _nameFields[i],
                _telFields[i],
                _addressFields[i],
              ],
            ),
            decoration: InputDecoration(
              labelText: i.toString(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        )
    ];
    return SingleChildScrollView(
      child: Column(
        children: children,
      ),
    );
  }

  final _okController = TextEditingController();
  Widget _okButton(BuildContext context) {
    final textField = TextField(
      controller: _okController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
    );

    final button = ElevatedButton(
      onPressed: () async {
        final index = int.parse(_okController.text);
        String text = "name: ${_groupControllers[index].name.text}\n" +
            "tel: ${_groupControllers[index].tel.text}\n" +
            "address: ${_groupControllers[index].address.text}\n";
        await showMessage(context, text, "Result");
      },
      child: Text("OK"),
    );

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          child: textField,
          width: 100,
          height: 50,
        ),
        button,
      ],
    );
  }
}
