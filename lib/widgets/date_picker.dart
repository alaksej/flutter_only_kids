import 'package:flutter/material.dart';
import 'package:only_kids/utils/utils.dart';

final int yearsToShow = 100;
final int daysPerYear = 365;

class DatePicker extends StatelessWidget {
  const DatePicker({
    Key key,
    this.selectedDate,
    this.selectDate,
    this.isReadonly = false,
  }) : super(key: key);

  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;
  final isReadonly;

  bool _isSelectable(DateTime date) => startOfDay(date).compareTo(startOfToday) >= 0;
  DateTime get now => DateTime.now();
  DateTime get startOfToday => startOfDay(now);
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
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final ThemeData themeData = Theme.of(context);
    final TextTheme headerTextTheme = themeData.primaryTextTheme;
    Color dayColor;
    Color yearColor;

    switch (themeData.primaryColorBrightness) {
      case Brightness.light:
        dayColor = Colors.black87;
        yearColor = Colors.black54;
        break;
      case Brightness.dark:
        dayColor = Colors.white;
        yearColor = Colors.white70;
        break;
    }

    final TextStyle dayStyle = headerTextTheme.display1.copyWith(color: dayColor);
    final TextStyle yearStyle = headerTextTheme.subhead.copyWith(color: yearColor);

    Color backgroundColor;
    switch (themeData.brightness) {
      case Brightness.light:
        backgroundColor = themeData.primaryColor;
        break;
      case Brightness.dark:
        backgroundColor = themeData.backgroundColor;
        break;
    }

    return Container(
      height: 80,
      decoration: BoxDecoration(color: backgroundColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildArrow(Icons.chevron_left, dayColor, onTap: _isSelectable(prevDay) ? goPrevDay : null),
          Expanded(
            child: InkWell(
              onTap: !isReadonly ? () => _pickDate(context) : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(localizations.formatYear(selectedDate), style: yearStyle),
                      Text(localizations.formatMediumDate(selectedDate), style: dayStyle),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _buildArrow(Icons.chevron_right, dayColor, onTap: _isSelectable(nextDay) ? goNextDay : null),
        ],
      ),
    );
  }

  InkWell _buildArrow(IconData icon, Color color, {void Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40,
        child: Icon(
          icon,
          color: color,
        ),
      ),
    );
  }
}
