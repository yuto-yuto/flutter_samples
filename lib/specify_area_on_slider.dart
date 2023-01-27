import 'package:flutter/material.dart';

class SpecifyAreaOnSlider extends StatefulWidget {
  const SpecifyAreaOnSlider({Key? key}) : super(key: key);

  @override
  _SpecifyAreaOnSliderState createState() => _SpecifyAreaOnSliderState();
}

class _SpecifyAreaOnSliderState extends State<SpecifyAreaOnSlider> {
  final keyForSlider = GlobalKey();
  double sliderPosition = 0;
  double? startRelativePosition;
  double? endRelativePosition;
  double? leftGlobalX;
  double? rightGlobalX;
  double? selectedAreaWidth;

  double get sliderWidth {
    final renderBox = keyForSlider.currentContext?.findRenderObject() as RenderBox;
    return renderBox.size.width;
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
                });
              } else {
                setState(() {
                  startRelativePosition = sliderPosition;
                  leftGlobalX = sliderWidth * sliderPosition;
                  selectedAreaWidth = null;
                });
              }
              return;
            }

            if (endRelativePosition! <= sliderPosition) {
              if (startRelativePosition != null) {
                setState(() {
                  startRelativePosition == null;
                  leftGlobalX = null;
                  selectedAreaWidth = rightGlobalX!;
                });
              }
              return;
            }

            if (startRelativePosition == sliderPosition) {
              setState(() => startRelativePosition = null);
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
                  selectedAreaWidth = 0;
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
              setState(() => endRelativePosition = null);
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
