import 'package:flutter/material.dart';

class DoubleTapTableRowData {
  final String filepath;
  final String dataType;
  final String remark;

  DoubleTapTableRowData({
    required this.filepath,
    required this.dataType,
    required this.remark,
  });

  @override
  bool operator ==(Object other) {
    return other is DoubleTapTableRowData && other.hashCode == hashCode;
  }

  @override
  int get hashCode => Object.hash(filepath, dataType, remark);
}

class _DoubleTapChecker<T> {
  T? _lastSelectedItem;
  DateTime _lastTimestamp = DateTime.now();

  bool isDoubleTap(T item) {
    if (_lastSelectedItem == null || _lastSelectedItem != item) {
      _lastSelectedItem = item;
      _lastTimestamp = DateTime.now();
      return false;
    }

    final currentTimestamp = DateTime.now();
    final duration = currentTimestamp.difference(_lastTimestamp).inMilliseconds;
    _lastTimestamp = DateTime.now();
    print(
        "last: $_lastTimestamp, current: $currentTimestamp, duration: $duration");
    return duration < 400;
  }
}

class RowDoubleTap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RowDoubleTap();
}

class _RowDoubleTap extends State<RowDoubleTap> {
  List<DoubleTapTableRowData> data = [];
  final doubleTapChecker = _DoubleTapChecker<DoubleTapTableRowData>();
  String doubleTapText = "double tap result here";

  void _initializeData() {
    data = [
      DoubleTapTableRowData(
        filepath: "/home/user/abc.txt",
        dataType: "text",
        remark: "abc text",
      ),
      DoubleTapTableRowData(
        filepath: "/home/user/sound.wav",
        dataType: "wav",
        remark: "special sound",
      ),
      DoubleTapTableRowData(
        filepath: "/home/user/secret",
        dataType: "text",
        remark: "secret into",
      ),
    ];
  }

  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Row Double Tap"),
      ),
      body: Center(
        child: Column(
          children: [
            _doubleTapRow(),
            Text(doubleTapText),
          ],
        ),
      ),
    );
  }

  Widget _doubleTapRow() {
    return DataTable(
      showCheckboxColumn: false,
      columns: [
        DataColumn(label: Text('Filepath')),
        DataColumn(label: Text('Data type')),
        DataColumn(label: Text('Remark')),
      ],
      rows: data
          .map(
            (e) => DataRow(
              onSelectChanged: ((selected) {
                setState(() {
                  if (doubleTapChecker.isDoubleTap(e)) {
                    doubleTapText = "Double tapped ${e.filepath}";
                    return;
                  }
                  doubleTapText = "Single tap ${e.filepath}";
                });
              }),
              cells: [
                DataCell(Text(e.filepath)),
                DataCell(Text(e.dataType)),
                DataCell(
                  Text(e.remark),
                  onTap: () => setState(
                      () => doubleTapText = "onTap event for ${e.filepath}"),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
