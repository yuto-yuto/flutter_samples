import 'package:flutter/material.dart';

class GetWidgetInfo extends StatefulWidget {
  const GetWidgetInfo({Key? key}) : super(key: key);

  @override
  _GetWidgetInfoState createState() => _GetWidgetInfoState();
}

class _GetWidgetInfoState extends State<GetWidgetInfo> with WidgetsBindingObserver {
  final containerKey = GlobalKey(debugLabel: "container-key");
  double? height;
  double? width;
  double? top;
  double? bottom;
  double? left;
  double? right;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    // debugPrint("${containerKey.hashCode}: ${this.hashCode}");
    // debugPrint("${WidgetsBinding.instance.buildOwner!.globalKeyCount}");
    _updateData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Widget Info'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Colors.black,
              ),
            ),
            child: Container(
              key: containerKey,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(10),
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(
                width: 2,
                color: Colors.redAccent,
              )),
            ),
          ),
          TextButton(
              child: Text("Press here to show the info"),
              onPressed: () {
                _updateData();
              }),
          Text("top: ${top}"),
          Text("bottom: ${bottom}"),
          Text("left: ${left}"),
          Text("right: ${right}"),
          Text("height: ${height}"),
          Text("width: ${width}"),
        ],
      ),
    );
  }

  void _updateData() {
    final renderBox = containerKey.currentContext?.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    setState(() {
      height = renderBox.size.height;
      width = renderBox.size.width;
      left = position.dx;
      top = position.dy;
      right = position.dx + renderBox.size.width;
      bottom = position.dy + renderBox.size.height;
    });
  }
}
