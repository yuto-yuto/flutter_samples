import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  {
    print("--- DateTime ---");
    print(DateTime(2020)); // 2020-01-01 00:00:00.000
    print(DateTime(2020, 12)); // 2020-12-01 00:00:00.000
    print(DateTime(2020, 12, 11, 10, 9, 8, 7, 6)); // 2020-12-11 10:09:08.007006
    print(DateTime.may); // 5
    print(DateTime.now()); // 2021-11-21 16:50:52.156693
    print(DateTime(2020, 12, 11, 10, 9, 8).toUtc()); // 2020-12-11 09:09:08.000Z
    print(DateTime.utc(2020, 12, 11, 10, 9, 8)); // 2020-12-11 10:09:08.000Z
    print(DateTime.daysPerWeek); // 7
    print(DateTime.monthsPerYear); // 12
    print(DateTime.monday); // 1
    print(DateTime.sunday); // 7

    print("--- DateTime format ---");
    final timestamp = DateTime(2021, 11, 12, 13, 14, 15, 123);
    print(timestamp); // 2021-11-12 13:14:15.123

    final formatter = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS");
    print(formatter.format(timestamp)); // 2021-11-12T13:14:15.123
    print(
        DateFormat("yyyyMMddHHmmssSSS").format(timestamp)); // 20211112131415123
    print(DateFormat("MM dd").format(timestamp)); // 11 12
    print(DateFormat("MMMd").format(timestamp)); // Nov 12
    print(DateFormat.MMMd().format(timestamp)); // Nov 12

    // Unhandled exception:
    // LocaleDataException: Locale data has not been initialized, call initializeDateFormatting(<locale>).
    await initializeDateFormatting();
    print(DateFormat.MMMd("en").format(timestamp)); // Nov 12
    print(DateFormat.MMMd("ja").format(timestamp)); // 11月12日
    print(DateFormat.MMMd("de").format(timestamp)); // 12. Nov.

    final time = DateTime(2021, 10, 11, 20, 0, 15, 12);
    print(DateFormat.yMd("en").add_jms().format(time)); // 10/11/2021 8:00:15 PM
    print(DateFormat.yMd("en").add_Hms().format(time)); // 10/11/2021 20:00:15
    print(DateFormat.yMd("ja").add_jms().format(time)); // 2021/10/11 20:00:15
    print(DateFormat.yMd("ja").add_Hms().format(time)); // 2021/10/11 20:00:15
    print(DateFormat.yMd("de").add_jms().format(time)); // 11.10.2021 20:00:15
    print(DateFormat.yMd("de").add_Hms().format(time)); // 11.10.2021 20:00:15
  }
  {
    print("--- DateTime add/subtract ---");
    final datetime = DateTime(2021, 9, 12, 10, 11, 22, 33);
    print(datetime); // 2021-09-12 10:11:22.033
    print(datetime.add(Duration(days: 1))); // 2021-09-13 10:11:22.033
    print(datetime.add(Duration(hours: 10))); // 2021-09-12 20:11:22.033
    print(datetime.add(Duration(minutes: 10))); // 2021-09-12 10:21:22.033
    print(datetime.add(Duration(seconds: 10))); // 2021-09-12 10:11:32.033
    print(datetime.add(Duration(milliseconds: 10))); // 2021-09-12 10:11:22.043
    print(
        datetime.add(Duration(microseconds: 10))); // 2021-09-12 10:11:22.033010
    print(datetime.subtract(Duration(days: 1))); // 2021-09-11 10:11:22.033
  }
  {
    print("--- DateTime comparison ---");
    final datetime = DateTime(2021, 9, 12, 10, 11, 22, 33);
    final datetime2 = datetime.add(Duration(days: 2));
    print(datetime2.compareTo(datetime2)); // 0
    print(datetime.compareTo(datetime2)); // -1
    print(datetime2.compareTo(datetime)); // 1

    print(datetime.isAtSameMomentAs(datetime)); // true
    print(datetime.isAtSameMomentAs(datetime2)); // false
    print(datetime.isBefore(datetime2)); // true
    print(datetime.isBefore(datetime)); // false
    print(datetime.isAfter(datetime2)); // false
    print(datetime.isAfter(datetime)); // false

    final time1 = DateTime(2020);
    final time2 = DateTime.utc(2020);
    print(time1.timeZoneName); // Western European Time
    print(time1.timeZoneOffset.inHours); // 1
    print(time1.toUtc()); // 2019-12-31 23:00:00.000Z
    print(time2);         // 2020-01-01 00:00:00.000Z
    print(time1.isAtSameMomentAs(time2)); // false
    print(time1.compareTo(time2)); // -1
    print(time1.isBefore(time2)); // true
    
    print(datetime.difference(datetime2).inHours); // -48
    print(datetime2.difference(datetime).inHours); // 48
    print(datetime2.difference(datetime).inMinutes); // 2880
  }

  {
    print("--- String to DateTime ---");
    void isDateTime(Object? object) {
      print(object is DateTime);
    }

    isDateTime(DateTime.parse("2020-11-11 10:10:12")); // true
    isDateTime(DateTime.tryParse("2020-11-11 10:10:12")); // true
    isDateTime(DateTime.tryParse("20201111 10:10:12")); // true
    isDateTime(DateTime.tryParse("20201111101012")); // false
    isDateTime(DateTime.tryParse("20201111T101012")); // true

    // FormatException: Trying to read MM from 20201111101012 at position 14
    // isDateTime(new DateFormat("yyyyMMddhhmmss").parse("20201111101012"));

    final timestamp = "20201111101012";
    final validStyle = timestamp.substring(0, 8) + "T" + timestamp.substring(8);
    isDateTime(DateTime.parse(validStyle)); // true
  }
}
