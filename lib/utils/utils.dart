import 'package:intl/intl.dart';

String dayDateTime(DateTime date) => DateFormat.EEEE().add_yMMMd().add_jm().format(date);
String dayDate(DateTime date) => DateFormat.EEEE().add_yMMMd().format(date);
String day(DateTime date) => DateFormat.EEEE().format(date);
String shortDate(DateTime date) => DateFormat.yMMMd().format(date);
String time(DateTime date) => DateFormat.jm().format(date);
DateTime startOfDay(DateTime date) => DateTime(date.year, date.month, date.day);
