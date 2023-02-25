import 'dart:math';

import 'package:flutter/material.dart';
import 'common.dart';
import 'package:flutter/services.dart';

class SelectRowWithShiftKey extends StatefulWidget {
  const SelectRowWithShiftKey({Key? key}) : super(key: key);

  @override
  _SelectRowWithShiftKeyState createState() => _SelectRowWithShiftKeyState();
}

class MyRowDataClass {
  bool selected = false;
  String text1;
  String text2;
  String text3;
  MyRowDataClass({
    required this.text1,
    required this.text2,
    required this.text3,
  });
}

class _SelectRowWithShiftKeyState extends State<SelectRowWithShiftKey> {
  final focusNodeForDataTable = FocusNode();
  String text = "";
  final columnCount = 3;
  final rowCount = 10;
  List<MyRowDataClass> data = [];
  final scrollController = ScrollController();
  bool isControlPressed = false;
  bool isShiftPressed = false;
  int? lastSelectedRowIndex;

  @override
  void initState() {
    super.initState();
    data = List.generate(
      rowCount,
      (index) => MyRowDataClass(text1: "$index-1", text2: "$index-2", text3: "$index-3"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: KeyboardListener(
        autofocus: true,
        focusNode: focusNodeForDataTable,
        onKeyEvent: (value) {
          debugPrint("Key: ${value.logicalKey.keyLabel}, state ${value.runtimeType.toString()}");
          if (value.logicalKey == LogicalKeyboardKey.controlLeft ||
              value.logicalKey == LogicalKeyboardKey.controlRight) {
            setState(() {
              isControlPressed = value is KeyDownEvent ? true : false;
              text = "Control key ${isControlPressed ? "ON" : "OFF"}";
            });
          } else if (value.logicalKey == LogicalKeyboardKey.shiftLeft ||
              value.logicalKey == LogicalKeyboardKey.shiftRight) {
            setState(() {
              isShiftPressed = value is KeyDownEvent
                  ? true
                  : value is KeyUpEvent
                      ? false
                      : isShiftPressed;
              text = "Shift key ${isShiftPressed ? "ON" : "OFF"}";
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Select row with ctrl/shift key"),
          ),
          body: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _generateDataTable(),
                generateContainer(child: Center(child: Text(text))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _generateDataTable() {
    return DataTable(
      showCheckboxColumn: true,
      columns: List.generate(
        columnCount,
        (index) => DataColumn(label: Text("Column-$index")),
      ),
      rows: data.map((row) => _generateDataRow(row)).toList(),
    );
  }

  DataRow _generateDataRow(MyRowDataClass row) {
    return DataRow(
      selected: row.selected,
      cells: [
        DataCell(Text(row.text1)),
        DataCell(Text(row.text2)),
        DataCell(Text(row.text3)),
      ],
      onSelectChanged: (value) {
        final currentIndex = data.indexOf(row);

        if (!isControlPressed && !isShiftPressed) {
          final selectedRows = data.where((element) => element.selected);
          setState(() {
            for (final row in selectedRows) {
              row.selected = false;
            }
            row.selected = value ?? false;
          });
        } else if (isControlPressed) {
          setState(() {
            row.selected = value ?? false;
          });
        } else {
          if (lastSelectedRowIndex == null) {
            setState(() {
              row.selected = value ?? false;
            });
          } else {
            final diff = lastSelectedRowIndex! - currentIndex;
            final selectedIndexes = List.generate(
              diff.abs() + 1,
              (index) => index + min(lastSelectedRowIndex!, currentIndex),
            );
            setState(() {
              for (int i = 0; i < data.length; i++) {
                data[i].selected = selectedIndexes.contains(i) ? true : false;
              }
            });
            return;
          }
        }
        debugPrint(lastSelectedRowIndex.toString());
        lastSelectedRowIndex = row.selected ? currentIndex : null;
      },
    );
  }
}
