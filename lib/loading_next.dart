import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<int> _data = [for (var i = 0; i < 200; i++) i];
Future<List<int>> _fetch(int count) {
  return Future.delayed(
    Duration(seconds: 2),
    () => _data.where((element) => element < count).toList(),
  );
}

class ScrollListener extends StatefulWidget {
  final Widget Function(BuildContext, ScrollController) builder;
  final VoidCallback loadNext;
  final double threshold;
  ScrollListener({
    required this.threshold,
    required this.builder,
    required this.loadNext,
  });

  @override
  _ScrollListener createState() => _ScrollListener();
}

class _ScrollListener extends State<ScrollListener> {
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final rate = _controller.offset / _controller.position.maxScrollExtent;
      if (widget.threshold <= rate) {
        widget.loadNext();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _controller);
  }
}

class LoadingNext extends StatefulWidget {
  @override
  _LoadingNext createState() => _LoadingNext();
}

class _LoadingNext extends State<LoadingNext> {
  int _count = 50;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Loading next data"),
        ),
        body: _createBody(context),
      ),
    );
  }

  Widget _createBody(BuildContext context) {
    return FutureBuilder(
      future: _fetch(_count),
      builder: (BuildContext context, AsyncSnapshot<List<int>?> snapshot) {
        final data = snapshot.data;
        if (data == null) {
          return Center(child: CircularProgressIndicator());
        }

        Widget _createListView() {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(title: Text("Item number - ${data[index]}"));
            },
          );
        }

        Widget _createListView2() {
          final controller = ScrollController();
          controller.addListener(() {
            final position =
                controller.offset / controller.position.maxScrollExtent;
            if (position >= 0.8) {
              if (data.length == _count && _count < _data.length) {
                setState(() {
                  _count += 50;
                });
              }
            }
          });
          return ListView.builder(
            controller: controller,
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(title: Text("Item number - ${data[index]}"));
            },
          );
        }

        Widget _createListView3() {
          return ScrollListener(
            threshold: 0.8,
            builder: (context, controller) {
              final listView = ListView.builder(
                controller: controller,
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(title: Text("Item number - ${data[index]}"));
                },
              );

              // if (data.length != _count) {
              //   return Stack(
              //     children: [
              //       listView,
              //       Center(child: CircularProgressIndicator()),
              //     ],
              //   );
              // } else {
              //   return listView;
              // }

              return Stack(
                children: [
                  listView,
                  // Opacity(
                  //   opacity: data.length != _count ? 1 : 0,
                  //   child: Center(child: CircularProgressIndicator()),
                  // ),
                  Visibility(
                    visible: data.length != _count,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              );
            },
            loadNext: () {
              if (data.length == _count && _count < _data.length) {
                setState(() {
                  _count += 50;
                });
              }
            },
          );
        }

        // return _createListView();
        // return _createListView2();
        return _createListView3();
      },
    );
  }
}
