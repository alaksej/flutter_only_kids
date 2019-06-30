import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final int yearsToShow = 100;
final int daysPerYear = 365;

class DatePicker extends StatelessWidget {
  const DatePicker({
    Key key,
    this.selectedDate,
    this.selectDate,
  }) : super(key: key);

  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;

  bool _isSelectable(DateTime date) {
    return date.isAfter(startOfToday);
  }

  DateTime get now => DateTime.now();
  DateTime get startOfToday => DateTime(now.year, now.month, now.day);
  DateTime get lastDate => startOfToday.add(Duration(days: yearsToShow * daysPerYear));

  Future<void> _pickDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: startOfToday,
      lastDate: lastDate,
      selectableDayPredicate: _isSelectable,
    );
    if (picked != null && picked != selectedDate) _selectDate(picked);
  }

  void _selectDate(DateTime date) {
    if (!_isSelectable(date)) {
      return;
    }
    selectDate(date);
  }

  DateTime get prevDay => selectedDate.subtract(Duration(days: 1));
  DateTime get nextDay => selectedDate.add(Duration(days: 1));

  void goPrevDay() {
    _selectDate(prevDay);
  }

  void goNextDay() {
    _selectDate(nextDay);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildArrow(Icons.arrow_left, onTap: _isSelectable(prevDay) ? goPrevDay : null),
          Expanded(
            child: InkWell(
              onTap: () => _pickDate(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.calendar_today,
                    size: 50,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  const SizedBox(width: 12.0),
                  Text(
                    DateFormat.yMMMd().format(selectedDate),
                    style: Theme.of(context).textTheme.headline,
                  ),
                ],
              ),
            ),
          ),
          _buildArrow(Icons.arrow_right, onTap: _isSelectable(nextDay) ? goNextDay : null),
        ],
      ),
    );
  }

  InkWell _buildArrow(IconData icon, {void Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40,
        child: Icon(icon),
      ),
    );
  }
}