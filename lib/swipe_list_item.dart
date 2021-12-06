import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_samples/show_dialog.dart';

class SwipeListItem extends StatefulWidget {
  @override
  _SwipeListItem createState() => _SwipeListItem();
}

class _SwipeListItem extends State<SwipeListItem> {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  List<int> _data = [for (var i = 0; i < 50; i++) i];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text("Swipe List Item"),
        ),
        body: _createBody(context),
      ),
    );
  }

  Widget _createBody(BuildContext context) {
    final count = _data.length;
    final countDisp = Text("Count: ${_data.length}");
    final leftEditIcon = Container(
      color: Colors.green,
      child: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          // edit
        },
      ),
      alignment: Alignment.centerLeft,
    );
    final rightDeleteIcon = Container(
      color: Colors.red,
      child: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          // delete
        },
      ),
      alignment: Alignment.centerRight,
    );

    final listView = ListView.builder(
        itemCount: count,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ObjectKey(_data[index]),
            child: ListTile(
              title: Text("Item number - ${_data[index]}"),
            ),
            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.startToEnd) {
                // Left to right
                print("Edit");
              } else if (direction == DismissDirection.endToStart) {
                // Right to left
                print("Delete");

                // ----- Delete item immediately
                setState(() {
                  int deletedItem = _data.removeAt(index);
                  final timer = Timer(
                    Duration(seconds: 3),
                    () {
                      showMessage(
                        context,
                        "Execute delete query for database",
                        "Database Access here",
                      );
                    },
                  );

                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        duration: Duration(
                          seconds: 2,
                          milliseconds: 500,
                        ),
                        content: Text("Deleted \"Item number - $deletedItem\""),
                        action: SnackBarAction(
                          label: "UNDO",
                          onPressed: () => setState(
                            () => _data.insert(index, deletedItem),
                          ),
                        ),
                      ),
                    );
                });
              }
            },
            confirmDismiss: (DismissDirection direction) async {
              if (direction == DismissDirection.startToEnd) {
                await showMessage(context, "Go to edit page", "Edit");
                return false;
              } else {
                return Future.value(direction == DismissDirection.endToStart);
              }
            },
            background: leftEditIcon,
            secondaryBackground: rightDeleteIcon,
            onResize: () {
              print("onResize");
            },
            // resizeDuration: Duration(seconds: 3),
            // movementDuration: Duration(seconds: 2),
          );
        });

    return Column(
      children: [
        Center(child: countDisp),
        Flexible(child: listView),
      ],
    );
  }
}
