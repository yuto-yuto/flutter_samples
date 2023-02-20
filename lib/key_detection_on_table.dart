import 'package:flutter/material.dart';
import 'common.dart';
import 'key_listener_with_check_box.dart';

class KeyDetectionOnTable extends StatefulWidget {
  const KeyDetectionOnTable({Key? key}) : super(key: key);

  @override
  _KeyDetectionOnTableState createState() => _KeyDetectionOnTableState();
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

class _KeyDetectionOnTableState extends State<KeyDetectionOnTable> {
  final focusNodeForDataTable = FocusNode();
  String text = "";
  final columnCount = 3;
  final rowCount = 10;
  List<MyRowDataClass> data = [];
  final scrollController = ScrollController();

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
          debugPrint("Key: ${value.logicalKey.keyLabel}");
          if (value.logicalKey.keyLabel == "Delete") {
            setState(() {
              text = value.logicalKey.keyLabel;
              data.removeWhere((element) => element.selected);
            });
          } else {
            setState(() {
              text = value.logicalKey.keyLabel;
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Key Detection On Data Table"),
          ),
          body: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            child: Column(children: [
              createButtonForPage(context, KeyListenerWithCheckBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _generateDataTable(),
                  generateContainer(child: Center(child: Text(text))),
                ],
              ),
            ]),
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
        setState(() {
          row.selected = value ?? false;
        });
      },
    );
  }
}
