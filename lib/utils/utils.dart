import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String dayDateTime(BuildContext context, DateTime date) {
  final MaterialLocalizations localizations = MaterialLocalizations.of(context);
  return '${localizations.formatFullDate(date)} ${localizations.formatTimeOfDay(TimeOfDay.fromDateTime(date))}';
}

String dayDate(DateTime date) => DateFormat.EEEE().add_yMMMd().format(date);
String day(DateTime date) => DateFormat.EEEE().format(date);
String shortDate(DateTime date) => DateFormat.yMMMd().format(date);
String time(DateTime date) => DateFormat.jm().format(date);
DateTime startOfDay(DateTime date) => DateTime(date.year, date.month, date.day);
DateTime fromDateAndTime(DateTime date, TimeOfDay time) => DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

TimeOfDay stringToTime(String s) {
  final int hour = int.parse(s.split(":")[0]);
  final int minute = int.parse(s.split(":")[1]);
  final TimeOfDay time = TimeOfDay(hour: hour, minute: minute);
  return time;
}

int compareTimeOfDay(TimeOfDay a, TimeOfDay b) {
  final int minutesA = a.hour * 60 + a.minute;
  final int minutesB = b.hour * 60 + b.minute;
  return minutesA > minutesB ? 1 : minutesA < minutesB ? -1 : 0;
}

Future<dynamic> showConfirmationDialog(BuildContext context, String title, String content, String confirmButton,
    [String closeButtton = 'Close']) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text(title),
        content: new Text(content),
        actions: <Widget>[
          new TextButton(
            child: new Text(closeButtton.toUpperCase()),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          new TextButton(
            child: new Text(confirmButton.toUpperCase()),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}

void showSnackBar({BuildContext? context, ScaffoldState? scaffoldState, durationSeconds = 3, String? text}) {
  assert((scaffoldState != null) ^ (context != null));
  // TODO
  // final SnackBar snackBar = SnackBar(
  //   duration: Duration(seconds: durationSeconds),
  //   content: Text(text!),
  // );
  // if (scaffoldState != null) {
  //   scaffoldState.showSnackBar(snackBar);
  // } else if (context != null) {
  //   Scaffold.of(context).showSnackBar(snackBar);
  // }
}
