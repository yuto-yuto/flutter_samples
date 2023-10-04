import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final hourLastProvider = StateProvider<String>((ref) => "00");
final minLastProvider = StateProvider<String>((ref) => "00");
final secLastProvider = StateProvider<String>((ref) => "00");

class TimeInputByTextField extends HookConsumerWidget {
  TimeInputByTextField({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hourFocus = useFocusNode();
    final minFocus = useFocusNode();
    final secFocus = useFocusNode();

    final hourController = useTextEditingController(text: "00");
    final minController = useTextEditingController(text: "00");
    final secController = useTextEditingController(text: "00");

    useEffect(() {
      final hourListener = () => formatTime(
            context,
            ref,
            lastProvider: hourLastProvider,
            controller: hourController,
            nextFocus: minFocus,
          );
      final minListener = () => formatTime(
            context,
            ref,
            lastProvider: minLastProvider,
            controller: minController,
            nextFocus: secFocus,
            hasLimit: true,
          );
      final secListener = () => formatTime(
            context,
            ref,
            lastProvider: secLastProvider,
            controller: secController,
            hasLimit: true,
          );

      hourController.addListener(hourListener);
      minController.addListener(minListener);
      secController.addListener(secListener);

      return () {
        hourController.removeListener(hourListener);
        minController.removeListener(minListener);
        secController.removeListener(secListener);
      };
    });

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Time input by TextField"),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                child: generateTextField(hourController, hourFocus, label: "HH"),
              ),
              Text(":"),
              SizedBox(
                width: 50,
                child: generateTextField(minController, minFocus, label: "MM"),
              ),
              Text(":"),
              SizedBox(
                width: 50,
                child: generateTextField(secController, secFocus, label: "SS"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget generateTextField(
    TextEditingController controller,
    FocusNode focusNode, {
    required String label,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        floatingLabelAlignment: FloatingLabelAlignment.center,
        labelText: label,
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: Colors.lightBlue),
        ),
      ),
      focusNode: focusNode,
      showCursor: false,
      onTap: () => controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      ),
      onSubmitted: (value) => paddingZero(controller),
      onTapOutside: (event) => paddingZero(controller),
      textInputAction: TextInputAction.next,
      maxLength: 3,
      buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
    );
  }

  void formatTime(
    BuildContext context,
    WidgetRef ref, {
    required StateProvider<String> lastProvider,
    required TextEditingController controller,
    FocusNode? nextFocus,
    hasLimit = false,
  }) {
    if (ref.read(lastProvider.notifier).state == controller.text) {
      return;
    }
    if (controller.text.isEmpty) {
      controller.text = "00";
    }
    ref.read(lastProvider.notifier).state = controller.text;

    if (controller.text.length == 3) {
      controller.text = controller.text[2];
      controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
      return;
    }

    final num = int.parse(controller.text);

    if (controller.text.length == 2) {
      focusOrUnfocus(context, nextFocus);
      return;
    }

    if (controller.text.length == 1 && hasLimit && num > 5) {
      controller.text = controller.text.padLeft(2, "0");
      focusOrUnfocus(context, nextFocus);
    }
  }

  void focusOrUnfocus(BuildContext context, FocusNode? focus) {
    if (focus != null) {
      FocusScope.of(context).requestFocus(focus);
    } else {
      FocusScope.of(context).unfocus();
    }
  }

  void paddingZero(TextEditingController controller) {
    if (controller.text.length == 1) {
      controller.text = controller.text.padLeft(2, "0");
    }
  }
}
