import 'package:flutter/material.dart';

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx + 100;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width - 100 * 2;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class SpecifyAreaOnSlider extends StatefulWidget {
  const SpecifyAreaOnSlider({Key? key}) : super(key: key);

  @override
  _SpecifyAreaOnSliderState createState() => _SpecifyAreaOnSliderState();
}

class _SpecifyAreaOnSliderState extends State<SpecifyAreaOnSlider> with WidgetsBindingObserver {
  final keyForSlider = GlobalKey();
  double sliderPosition = 0;
  double? startRelativePosition;
  double? endRelativePosition;
  double? _leftGlobalX;
  double? _rightGlobalX;
  double? selectedAreaWidth;

  double get sliderWidth {
    final renderBox = keyForSlider.currentContext?.findRenderObject() as RenderBox;
    return renderBox.size.width - (14 + 8) * 2;
  }

  void set leftGlobalX(double? value) {
    if (value != null) {
      _leftGlobalX = value + 22;
    } else {
      _leftGlobalX = null;
    }
  }

  double? get leftGlobalX => _leftGlobalX;

  void set rightGlobalX(double? value) {
    if (value != null) {
      _rightGlobalX = value + 22;
    } else {
      _rightGlobalX = null;
    }
  }

  double? get rightGlobalX => _rightGlobalX;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (_leftGlobalX != null && _rightGlobalX == null) {
      setState(() {
        leftGlobalX = startRelativePosition! * sliderWidth;
        selectedAreaWidth = sliderWidth * (1 - startRelativePosition!);
      });
    } else if (_leftGlobalX == null && _rightGlobalX != null) {
      setState(() {
        rightGlobalX = endRelativePosition! * sliderWidth;
        selectedAreaWidth = _rightGlobalX!;
      });
    } else if (_leftGlobalX != null && _rightGlobalX != null) {
      setState(() {
        leftGlobalX = startRelativePosition! * sliderWidth;
        rightGlobalX = endRelativePosition! * sliderWidth;
        selectedAreaWidth = _rightGlobalX! - leftGlobalX!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final slider = Slider(
      key: keyForSlider,
      onChanged: (double v) {
        setState(() {
          sliderPosition = v;
        });
      },
      value: sliderPosition,
    );
    final sliderTheme = SliderTheme(
      data: SliderThemeData(
        overlayShape: SliderComponentShape.noThumb,
        trackShape: CustomTrackShape(),
      ),
      child: slider,
    );

    final buttons = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextButton(
          child: generateBorderedText("Init"),
          onPressed: () => setState(() {
            startRelativePosition = null;
            endRelativePosition = null;
            leftGlobalX = null;
            rightGlobalX = null;
            selectedAreaWidth = null;
          }),
        ),
        TextButton(
          child: generateBorderedText("A"),
          onPressed: () => setState(() {
            if (endRelativePosition == null) {
              if (startRelativePosition == sliderPosition) {
                setState(() {
                  startRelativePosition = null;
                  leftGlobalX = null;
                  selectedAreaWidth = null;
                });
              } else {
                setState(() {
                  startRelativePosition = sliderPosition;
                  leftGlobalX = sliderWidth * sliderPosition;
                  selectedAreaWidth = sliderWidth * (1 - sliderPosition);
                });
              }
              return;
            }

            if (endRelativePosition! <= sliderPosition || startRelativePosition == sliderPosition) {
              if (startRelativePosition != null) {
                setState(() {
                  startRelativePosition = null;
                  leftGlobalX = null;
                  selectedAreaWidth = rightGlobalX!;
                });
              }
              return;
            }

            if (endRelativePosition! > sliderPosition) {
              setState(() {
                startRelativePosition = sliderPosition;
                leftGlobalX = sliderWidth * sliderPosition;
                selectedAreaWidth = rightGlobalX! - leftGlobalX!;
              });
            }
          }),
        ),
        TextButton(
          child: generateBorderedText("B"),
          onPressed: () {
            if (startRelativePosition == null) {
              setState(() {
                if (endRelativePosition == sliderPosition) {
                  endRelativePosition = null;
                  rightGlobalX = null;
                  selectedAreaWidth = null;
                } else {
                  endRelativePosition = sliderPosition;
                  rightGlobalX = sliderWidth * sliderPosition;
                  selectedAreaWidth = rightGlobalX;
                }
              });
              return;
            }

            if (startRelativePosition! >= sliderPosition) {
              if (endRelativePosition != null) {
                setState(() {
                  endRelativePosition = null;
                  rightGlobalX = null;
                  selectedAreaWidth = null;
                });
              }
              return;
            }

            if (endRelativePosition == sliderPosition) {
              setState(() {
                endRelativePosition = null;
                rightGlobalX = null;
                selectedAreaWidth = sliderWidth * (1 - startRelativePosition!);
              });
              return;
            }
            if (startRelativePosition! < sliderPosition) {
              setState(() {
                endRelativePosition = sliderPosition;
                rightGlobalX = sliderWidth * sliderPosition;
                selectedAreaWidth = rightGlobalX! - leftGlobalX!;
              });
            }
          },
        ),
      ],
    );

    final stack = Stack(
      children: [
        Positioned(
          top: 10,
          left: leftGlobalX,
          child: ColoredBox(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
            child: SizedBox(
              height: 30,
              width: selectedAreaWidth ?? 10,
            ),
          ),
        ),
        slider,
        // sliderTheme,
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Specify Area on Slider'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Slider'),
          buttons,
          stack,
          Text("Slider Position: ${sliderPosition.toStringAsPrecision(3)}"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("startRelativePosition: ${startRelativePosition?.toStringAsPrecision(3)}"),
              SizedBox(width: 20),
              Text("endRelativePosition: ${endRelativePosition?.toStringAsPrecision(3)}"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("leftGlobalX: ${leftGlobalX?.toStringAsPrecision(3)}"),
              SizedBox(width: 20),
              Text("rightGlobalX: ${rightGlobalX?.toStringAsPrecision(3)}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget generateBorderedText(String text) {
    return Container(
      child: Text(text),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
        color: Colors.black,
        width: 2,
      )),
    );
  }
}
