import 'package:intl/intl.dart';

String formatDate(DateTime date) => DateFormat.EEEE().add_yMMMd().add_jm().format(date);
DateTime startOfDay(DateTime date) => DateTime(date.year, date.month, date.day);
