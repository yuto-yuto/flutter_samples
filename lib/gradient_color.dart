import 'package:flutter/material.dart';

class GradientColor extends StatelessWidget {
  const GradientColor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Glanular Color"),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                linearWithoutParam(),
                withBeginAndEnd(),
                withStops(),
                differentGradientType(),
                SizedBox(height: 10),
                withCircle(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget linearWithoutParam() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.yellow,
            Colors.blue,
          ],
        ),
      ),
    );
  }

  Widget withBeginAndEnd() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text("topRight -> bottomLeft"),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.yellow,
                    Colors.blue,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text("topLeft -> topRight"),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.yellow,
                    Colors.blue,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget withStops() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text("stops [0.2, 0.3]"),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.yellow,
                    Colors.blue,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0.2, 0.3],
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text("stops [0.1, 0.9]"),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.yellow,
                    Colors.blue,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0.1, 0.9],
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text("stops [0.2, 0.3, 0.5, 0.8]"),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.yellow,
                    Colors.blue,
                    Colors.purple,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0.1, 0.4, 0.8],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget differentGradientType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text("SweepGradient"),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: SweepGradient(
                  colors: [
                    Colors.yellow,
                    Colors.blue,
                    Colors.purple,
                  ],
                  stops: [0.1, 0.4, 0.8],
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text("SweepGradient2"),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: SweepGradient(
                  colors: [
                    Colors.yellow,
                    Colors.blue,
                    Colors.purple,
                    Colors.yellow,
                  ],
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text("RadialGradient"),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.yellow,
                    Colors.blue,
                    Colors.purple,
                  ],
                  stops: [0.1, 0.4, 0.8],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget withCircle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            gradient: SweepGradient(
              colors: [
                Colors.yellow,
                Colors.blue,
                Colors.purple,
                Colors.yellow,
              ],
            ),
          ),
        ),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            gradient: RadialGradient(
              colors: [
                Colors.yellow,
                Colors.blue,
                Colors.purple,
              ],
              stops: [0, 0.4, 1],
            ),
          ),
        ),
      ],
    );
  }
}
