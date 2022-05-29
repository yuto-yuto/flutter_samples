import 'package:flutter/material.dart';

class CrossAxisScroll extends StatelessWidget {
  final _data = const [
    "1 long long word assdaffadfadafdafdsfasfdafdsaffdazfdasfdafdfafafdfadfafds",
    "2 long long word assdaffadfadafdafdsfasfdafdsaffdazfdasfdafdfafafdfadfafds",
    "3 long long word assdaffadfadafdafdsfasfdafdsaffdazfdasfdafdfafafdfadfafds",
    "4 long long word assdaffadfadafdafdsfasfdafdsaffdazfdasfdafdfafafdfadfafds",
    "5 long long word assdaffadfadafdafdsfasfdafdsaffdazfdasfdafdfafafdfadfafds",
    "6 long long word assdaffadfadafdafdsfasfdafdsaffdazfdasfdafdfafafdfadfafds",
    "7 long long word assdaffadfadafdafdsfasfdafdsaffdazfdasfdafdfafafdfadfafds",
    "8 long long word assdaffadfadafdafdsfasfdafdsaffdazfdasfdafdfafafdfadfafds",
    "9 long long word assdaffadfadafdafdsfasfdafdsaffdazfdasfdafdfafafdfadfafds",
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Cross Axis Scroll"),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Text("ListView vertical"),
              _wrap(context, _createListView(Axis.vertical)),
              Divider(),
              Text("ListView horizontal"),
              _wrap(context, _createListView(Axis.horizontal)),
              Divider(),
              Text("Cross axis: SingleChildScrollView * Column"),
              _wrap(context, _createCrossAxis()),
              Divider(),
              Text("DataTable cross axis"),
              _wrap(context, _createDataTable()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _wrap(BuildContext context, Widget widget) {
    return Container(
      child: widget,
      height: 150,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
      ),
    );
  }

  Widget _createListView(Axis direction) {
    return ListView.builder(
      scrollDirection: direction,
      itemCount: _data.length,
      itemBuilder: (context, index) => Card(child: Text(_data[index])),
    );
  }

  Widget _createCrossAxis() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: _data.map((e) => Card(child: Text(e))).toList(),
        ),
      ),
    );
  }

  // Error
  Widget _createCrossAxis2() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: _createListView(Axis.vertical),
    );
  }

  Widget _createDataTable() {
    final columns = List.generate(
      20,
      (index) => DataColumn(
        label: Text("column $index"),
      ),
    );

    final rows = List.generate(
      20,
      (rowIndex) => DataRow(
        cells: List.generate(
          20,
          (cellIndex) => DataCell(
            Text("data $cellIndex-$rowIndex"),
          ),
        ),
      ),
    );

    final dataTable = DataTable(
      columns: columns,
      rows: rows,
      border: TableBorder.all(color: Colors.grey),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: dataTable,
      ),
    );
  }
}
