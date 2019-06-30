import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({
    Key key,
    this.selectedDate,
    this.selectDate,
  }) : super(key: key);

  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;

  bool _isSelectable(DateTime date) {
    final now = DateTime.now();
    final startOftoday = DateTime(now.year, now.month, now.day);
    return date.isAfter(startOftoday);
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2019),
      lastDate: DateTime(2101),
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

  void prevDay() {
    final date = selectedDate.subtract(Duration(days: 1));
    _selectDate(date);
  }

  void nextDay() {
    final date = selectedDate.add(Duration(days: 1));
    _selectDate(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildArrow(Icons.arrow_left, prevDay),
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
          _buildArrow(Icons.arrow_right, nextDay),
        ],
      ),
    );
  }

  InkWell _buildArrow(IconData icon, void Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40,
        child: Icon(icon),
      ),
    );
  }
}
