import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageTransition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Page Transition sample"),
        ),
        body: SizedBox.shrink(),
      ),
    );
  }
}

class _View1 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}