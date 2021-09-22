import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_expansion_tile/group_base.dart';
import 'package:grouped_expansion_tile/grouped_expansion_tile.dart';

class Category implements GroupBase {
  final String uid;
  final String name;
  final String? parent;
  Category({
    required this.uid,
    required this.name,
    this.parent,
  });
}

class GroupedExpansionTileSample extends StatelessWidget {
  List<Category> _createList() {
    return [
      Category(uid: "1", name: "group-1"),
      Category(uid: "2", name: "group-2"),
      Category(uid: "3", name: "group-1-1", parent: "1"),
      Category(uid: "4", name: "group-2-1", parent: "2"),
      Category(uid: "5", name: "group-3"),
      Category(uid: "6", name: "group-2-1-1", parent: "4"),
      Category(uid: "7", name: "group-2-2", parent: "2"),
      Category(uid: "8", name: "group-2-3", parent: "2"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final groupedExpansionTile = GroupedExpansionTile<Category>(
      data: _createList(),
      builder: (parent, depth) => Text(parent.self.name),
    );
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Grouped ExPansion Sample"),
      ),
      body: groupedExpansionTile,
    ));
  }
}
