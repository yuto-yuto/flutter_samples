import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class DialogSample extends StatefulWidget {
  @override
  _DialogSample createState() => _DialogSample();
}

class _DialogSample extends State<DialogSample> {
  String? result;

  @override
  Widget build(BuildContext context) {
    final defaultAlertDialog = ElevatedButton(
      onPressed: () async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(),
        );
      },
      child: Text("Default Alert Dialog"),
    );
    final alertDialogWithoutButton = ElevatedButton(
      onPressed: () async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text("Hello"),
          ),
        );
      },
      child: Text("Alert Dialog without button"),
    );
    final alertDialog = ElevatedButton(
      onPressed: () async {
        await showAlert(context, "Error message here");
      },
      child: Text("Alert Dialog without Title"),
    );
    final alertDialogWithTitle = ElevatedButton(
      onPressed: () async {
        await showAlert(context, "Error message here", "Message");
      },
      child: Text("Alert Dialog with Title"),
    );

    final alertDialogWithResult = ElevatedButton(
      onPressed: () async {
        final result =
            await showAlert(context, "Error message here", "Message");
        setState(() {
          this.result = result;
        });
      },
      child: Text("Alert Dialog with result"),
    );

    final alertList = ElevatedButton(
      onPressed: () async {
        final list = [for (int i = 0; i < 50; i++) i.toString()];
        final result = await showAlertList(context, list, "List");
        setState(() {
          this.result = result;
        });
      },
      child: Text("Alert List"),
    );
    final alertCupertino = CupertinoButton(
      onPressed: () async {
        final result = await showAlertCuperutino(
          context,
          "Error message for cupertino",
          "ERROR",
        );
        setState(() {
          this.result = result;
        });
      },
      child: Text("Cupertino Alert Dialog"),
    );
    final simpleDialog = ElevatedButton(
      onPressed: () async {
        final result = await selectAge(context);
        setState(() {
          this.result = result;
        });
      },
      child: Text("Simple Dialog"),
    );

    final clear = ElevatedButton(
      onPressed: () {
        setState(() {
          result = null;
        });
      },
      child: Text("CLEAR RESULT"),
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Dialog Sample"),
        ),
        body: Center(
          child: Column(
            children: [
              defaultAlertDialog,
              alertDialogWithoutButton,
              alertDialog,
              alertDialogWithTitle,
              alertDialogWithResult,
              alertList,
              alertCupertino,
              simpleDialog,
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text("result: ${result ?? ""}"),
              ),
              clear,
            ],
          ),
        ),
      ),
    );
  }

Future<String?> showAlert(
  BuildContext context,
  String msg, [
  String? title,
]) {
  final ok = TextButton(
    onPressed: () {
      Navigator.of(context).pop("OK");
    },
    child: Text("OK"),
  );

  final alert = AlertDialog(
    title: title != null ? Text(title) : null,
    content: Text(msg),
    actions: [ok],
  );

  return showDialog(
    context: context,
    builder: (BuildContext context) => alert,
  );
}

  Future<String?> showAlertList(
    BuildContext context,
    List<String> msg, [
    String? title,
  ]) {
    final ok = TextButton(
      onPressed: () {
        Navigator.of(context).pop("OK");
      },
      child: Text("OK"),
    );

    final alert = AlertDialog(
      title: title != null ? Text(title) : null,
      content: SingleChildScrollView(
        child: ListBody(
          children: msg.map((e) => Text(e)).toList(),
        ),
      ),
      actions: [ok],
    );

    return showDialog(
      context: context,
      builder: (BuildContext context) => alert,
    );
  }

  Future<String?> showAlertCuperutino(
    BuildContext context,
    String msg, [
    String? title,
  ]) async {
    final ok = CupertinoDialogAction(
      onPressed: () {
        Navigator.of(context).pop("OK");
      },
      child: Text("OK"),
    );

    final alert = CupertinoAlertDialog(
      title: title != null ? Text(title) : null,
      content: Text(msg),
      actions: [ok],
    );

    return showDialog(
      context: context,
      builder: (BuildContext context) => alert,
    );
  }

  Future<String?> selectAge(BuildContext context) {
    Widget _boldText(String text) {
      return Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
      );
    }

    final simple = SimpleDialog(
      title: Text("Age"),
      insetPadding: EdgeInsets.symmetric(horizontal: 120.0, vertical: 200.0),
      children: [
        for (int i = 0; i < 99; i++)
          SimpleDialogOption(
            child: Center(
              child: _boldText(i.toString()),
            ),
            onPressed: () {
              Navigator.of(context).pop(i.toString());
            },
          ),
      ],
    );
    return showDialog(
      context: context,
      builder: (context) => simple,
    );
  }
}
