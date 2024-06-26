import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_samples/custom_widgets/labeled_divider.dart';

typedef OnColorUpdate = void Function(Color color);

const List<Color> _colors = [
  Color.fromARGB(255, 255, 0, 0),
  Color.fromARGB(255, 255, 0, 255),
  Color.fromARGB(255, 0, 0, 255),
  Color.fromARGB(255, 0, 255, 255),
  Color.fromARGB(255, 0, 255, 0),
  Color.fromARGB(255, 255, 255, 0),
  Color.fromARGB(255, 255, 0, 0),
];

class CircularColor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CircularColorState();
}

class CircularColorState extends State<CircularColor> {
  Color currentColor = Colors.black;
  double alpha = 1.0;
  double brightness = 1.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Circular Color"),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LabeledDivider("Circular Color"),
              buildCircularColor(60),
              LabeledDivider("Circular Color with Opacity"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildCircularColorWithOpacity(60, Colors.black),
                  buildCircularColorWithOpacity(60, Color.fromARGB(0, 255, 255, 255)),
                ],
              ),
              LabeledDivider("Final artifact"),
              Container(
                height: 100,
                width: 300,
                decoration: BoxDecoration(
                  color: currentColor,
                ),
              ),
              GlanularCircularColorChart(
                radius: 150,
                alpha: alpha,
                brightness: brightness,
                onColorUpdate: (color) {
                  setState(() {
                    currentColor = color;
                  });
                },
              ),
              ...buildSliders(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCircularColor(double radius) {
    final diameter = 2 * radius;

    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
        gradient: const SweepGradient(
          colors: _colors,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 0.5,
          ),
        ],
      ),
    );
  }

  Widget buildCircularColorWithOpacity(double radius, Color second) {
    final diameter = 2 * radius;

    final opacityCircle = Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
        gradient: RadialGradient(
          colors: [
            Colors.white,
            second,
          ],
          stops: [0.0, 1.0],
        ),
      ),
    );

    return Stack(
      children: [
        buildCircularColor(radius),
        opacityCircle,
      ],
    );
  }

  List<Widget> buildSliders() {
    final alphaSlider = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("alpha"),
        Slider(
          value: alpha,
          divisions: 100,
          onChanged: (value) {
            setState(() {
              alpha = value;
              currentColor = currentColor.withOpacity(value);
            });
          },
        ),
      ],
    );

    final brightnessSlider = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("brightness"),
        Slider(
          value: brightness,
          min: 0.01,
          max: 1.0,
          divisions: 99,
          onChanged: (value) {
            setState(() {
              brightness = value;
              currentColor = HSVColor.fromColor(currentColor).withValue(value).toColor();
            });
          },
        ),
      ],
    );

    return [
      alphaSlider,
      brightnessSlider,
    ];
  }
}

class GlanularCircularColorChart extends StatelessWidget {
  final double radius;
  final double alpha;
  final double brightness;
  final OnColorUpdate? onColorUpdate;

  const GlanularCircularColorChart({
    super.key,
    required this.radius,
    this.alpha = 1.0,
    this.brightness = 1.0,
    this.onColorUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final diameter = 2 * radius;

    final colorCircle = Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
        gradient: const SweepGradient(
          colors: _colors,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 0.5,
          ),
        ],
      ),
    );

    final opacityCircle = Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
        gradient: const RadialGradient(
          colors: [
            Colors.white,
            Color.fromARGB(0, 255, 255, 255),
          ],
          stops: [0.0, 1.0],
        ),
      ),
    );

    final circularColorChart = Stack(
      children: [
        colorCircle,
        opacityCircle,
      ],
    );

    return SizedBox(
      width: diameter,
      height: diameter,
      child: buildTouchedArea(circularColorChart),
    );
  }

  Widget buildTouchedArea(Widget child) {
    return GestureDetector(
      // onTapDown: (details) => calculateColor(details.localPosition),
      onPanStart: (details) {
        calculateColor(details.localPosition);
      },
      onPanUpdate: (details) {
        calculateColor(details.localPosition);
      },
      onPanEnd: (details) {},
      child: child,
    );
  }

  void calculateColor(Offset position) {
    final distanceXFromCenter = position.dx - radius;
    final distanceYFromCenter = position.dy - radius;

    // distance from center to the touched position (x, y)
    final internalRadius = math.sqrt(
      math.pow(distanceXFromCenter, 2) + math.pow(distanceYFromCenter, 2),
    );

    // The range is -PI to PI.
    final radian = math.atan2(distanceXFromCenter, distanceYFromCenter);
    final degree = convertThetaToDegree(radian);

    final saturation = internalRadius >= radius ? 1.0 : internalRadius / radius;

    final correntColor = HSVColor.fromAHSV(alpha, degree, saturation, brightness).toColor();

    onColorUpdate?.call(correntColor);
  }

  /// convertThetaToDegree converts double value to 0 - 360.
  double convertThetaToDegree(double radian) {
    final degree = radian * (180 / math.pi) - 90;
    if (degree < 0) {
      return degree + 360;
    }
    if (degree > 360) {
      return degree % 360;
    }

    return degree;
  }
}
