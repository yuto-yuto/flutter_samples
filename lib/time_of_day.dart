import 'package:flutter/material.dart';

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}

class TimeOfDaySample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final time = TimeOfDay(hour: 21, minute: 12);
    final time2 = TimeOfDay(hour: 9, minute: 5);

    return Scaffold(
      appBar: AppBar(
        title: Text("Time Of Day"),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20),
        child: DefaultTextStyle.merge(
          style: TextStyle(fontSize: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("----- 21:12 -----"),
              Text("toString(): " + time.toString()),
              Text("format(): " + time.format(context)),
              Text("period.index: " + time.period.index.toString()),
              Text("period.name: " + time.period.name),
              Text("period.periodOffset: " + time.periodOffset.toString()),
              Text("24h: ${time.hour}:${time.minute}"),
              SizedBox(height: 20),
              Text("----- 09:05 -----"),
              Text("toString(): " + time2.toString()),
              Text("format(): " + time2.format(context)),
              Text("period.index: " + time2.period.index.toString()),
              Text("period.name: " + time2.period.name),
              Text("period.periodOffset: " + time2.periodOffset.toString()),
              Text("24h: ${time2.hour}:${time2.minute}"),
              Text("24h: ${time2.to24hours()}"),
              SizedBox(height: 20),
              Text("----- now -----"),
              Text("TimeOfDay.now().format(): " +
                  TimeOfDay.now().format(context)),
              Text("fromDateTime: " +
                  TimeOfDay.fromDateTime(DateTime.now()).format(context)),
            ],
          ),
        ),
      ),
    );
  }
}
