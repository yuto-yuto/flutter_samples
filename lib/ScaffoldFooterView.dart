import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScaffoldFooterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageView(
        children: [
          _createFloating(),
          _createPersistentFooter(),
          _createPersistentFooter2(),
        ],
      ),
    );
  }

  Widget _createFloating() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Floating Button"),
      ),
      body: ListView(
        children: [
          TextField(),
          TextField(),
          TextField(),
          TextField(),
          TextField(),
          TextField(),
        ],
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(onPressed: () {}, child: Text("Cancel")),
          ElevatedButton(onPressed: () {}, child: Text("OK")),
        ],
      ),
    );
  }

  Widget _createPersistentFooter() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Persistent Footer Button"),
      ),
      body: ListView(
        children: [
          TextField(),
          TextField(),
          TextField(),
          TextField(),
          TextField(),
        ],
      ),
      persistentFooterButtons: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(onPressed: () {}, child: Text("Cancel")),
            ElevatedButton(onPressed: () {}, child: Text("OK")),
          ],
        ),
      ],
    );
  }

  Widget _createPersistentFooter2() {
    return Scaffold(
      // appear on the keyboard
      appBar: AppBar(
        title: Text("Scaffold in Scaffold"),
      ),
      body: _createPersistentFooter(),
    );
  }
}
