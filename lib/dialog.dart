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
    final alertDialog = ElevatedButton(
      onPressed: () async {
        await alert(context, "Error message here");
      },
      child: Text("Alert Dialog without Title"),
    );
    final alertDialogWithTitle = ElevatedButton(
      onPressed: () async {
        await alert(context, "Error message here 2", "Message");
      },
      child: Text("Alert Dialog with Title"),
    );
    final alertDialogWithResult = ElevatedButton(
      onPressed: () async {
        final result = await alert(context, "Error message here 3", "Message");
        setState(() {
          this.result = result;
        });
      },
      child: Text("Alert Dialog with result"),
    );
    final alertCupertino = CupertinoButton(
      onPressed: () async {
        final result = await alertCuperutino(
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
              alertDialog,
              alertDialogWithTitle,
              alertDialogWithResult,
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

  Future<String?> alert(
    BuildContext context,
    String msg, [
    String? title,
  ]) async {
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

  Future<String?> alertCuperutino(
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
