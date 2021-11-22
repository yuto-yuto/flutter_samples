import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerSample extends StatelessWidget {
@override
Widget build(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      // drawer: _drawer(context),
      endDrawer: FractionallySizedBox(
        child: _drawer(context),
        widthFactor: 0.5,
      ),
      // drawerEnableOpenDragGesture: false,
      appBar: AppBar(
        title: Text("Drawer Sample"),
      ),
    ),
  );
}

  Widget _drawer(BuildContext context) {
    final header = DrawerHeader(
      // decoration: BoxDecoration(color: Colors.lightBlue),
      // child: Center(child: Text("Header text")),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.scaleDown,
          image: AssetImage("./lib/resources/logo_1200_630.jpg"),
        ),
      ),
      child: SizedBox.shrink(),
    );
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            child: header,
            height: 100,
          ),
          Center(child: Text("item 1")),
          Center(child: Text("item 2")),
          Center(child: Text("item 3")),
          Divider(color: Colors.black87),
          _generateItem(context, "Item 4"),
          _generateItem(context, "Item 5"),
          _generateItem(context, "Item 6"),
        ],
      ),
    );
  }

  Widget _generateItem(BuildContext context, String title) {
    return ListTile(
      title: Center(child: Text(title)),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => _NextView()),
        );
        Navigator.pop(context);
      },
      leading: Icon(Icons.kitchen),
    );
  }
}

class _NextView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Empty page"),
        ),
      ),
    );
  }
}
