import 'package:intl/intl.dart';

String formatDate(DateTime date) => DateFormat('EEEE MMM d, y').format(date);
DateTime startOfDay(DateTime date) => DateTime(date.year, date.month, date.day); 
