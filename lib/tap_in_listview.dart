import 'package:flutter/material.dart';

class TapInListview extends StatefulWidget {
  @override
  _TapInListview createState() => _TapInListview();
}

class _TapInListview extends State<TapInListview> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Tap in ListView"),
        ),
        body: ListView.builder(
          itemCount: 30,
          itemBuilder: (context, index) {
            final child = ListTile(
              title: Text("Something $index"),
            );
            // not work
            // return Draggable(
            //   affinity: Axis.horizontal,
            //   data: child,
            //   feedback: Material(
            //     child: ConstrainedBox(
            //       constraints: BoxConstraints(
            //           maxWidth: MediaQuery.of(context).size.width),
            //       child: Container(
            //         child: child,
            //         decoration: BoxDecoration(
            //           border: Border.all(color: Colors.red, width: 1),
            //         ),
            //       ),
            //     ),
            //   ),
            //   childWhenDragging: Opacity(opacity: 0.5, child: child),
            //   child: child,
            // );

            return GestureDetector(
              child: child,
              onTap: () {
                debugPrint("onTap on index $index");
              },
            );
          },
        ),
      ),
    );
  }
}
