import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RowDoubleTap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RowDoubleTap();
}

class _RowDoubleTap extends State<RowDoubleTap> {
  void alert() {
    showAboutDialog(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Row Double Tap"),
      ),
      body: Center(
        child: DataTable(
          columns: [
            DataColumn(label: Text('Col 1')),
            DataColumn(label: Text('Col 2')),
          ],
          rows: [
            DataRow(
              onSelectChanged: (bool? selected) {
                alert();
              },
              cells: [
                DataCell(
                  TableRowInkWell(
                    child: Container(color: Colors.red, child: Text('Val 1')),
                  ),
                  // onTap: alert,
                ),
                DataCell(TableRowInkWell(
                  child: Container(color: Colors.red, child: Text('Val 2')),
                  // onTap: alert,
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
