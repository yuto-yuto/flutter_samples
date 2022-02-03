import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatefulWidget {
  @override
  _DateTimePicker createState() => _DateTimePicker();
}

class _DateTimePicker extends State<DateTimePicker> {
  final _dateController = TextEditingController();
  final _timeController1 = TextEditingController();
  final _timeController2 = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    _timeController1.dispose();
    _timeController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Date Time Picker"),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            _datePicker(),
            _timePicker(
              controller: _timeController1,
              label: "Time 12h format",
              alwaysUse24HourFormat: false,
            ),
            SizedBox(
              height: 10,
            ),
            _timePicker(
              controller: _timeController2,
              label: "Time 24h format",
              alwaysUse24HourFormat: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _datePicker() {
    return TextField(
      controller: _dateController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: "Date",
        icon: Icon(Icons.event),
        hintText: "Date",
      ),
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          initialDate: DateTime.now(),
          selectableDayPredicate: (day) => day.isBefore(DateTime.now()),
        );
        if (selectedDate != null) {
          setState(() {
            _dateController.text = DateFormat.yMd().format(selectedDate);
          });
        }
      },
    );
  }

  Widget _timePicker({
    required TextEditingController controller,
    required String label,
    required bool alwaysUse24HourFormat,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        icon: Icon(Icons.access_time),
        hintText: "Time",
      ),
      onTap: () async {
        final selectedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(alwaysUse24HourFormat: alwaysUse24HourFormat),
              child: child!,
            );
          },
        );

        if (selectedTime != null) {
          final text = alwaysUse24HourFormat
              ? "${selectedTime.hour}:${selectedTime.minute}"
              : selectedTime.format(context);
          setState(() {
            controller.text = text;
          });
        }
      },
    );
  }
}
