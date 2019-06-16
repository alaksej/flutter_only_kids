import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentPage extends StatelessWidget {
  final DateTime _fromDate = DateTime.now();
  final TimeOfDay _fromTime = _DateTimePicker.timeList[0];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Schedule an Appointment',
                  style: Theme.of(context).textTheme.body2,
                ),
              ],
            ),
            _DateTimePicker(
              selectedDate: _fromDate,
              selectedTime: _fromTime,
              selectDate: (DateTime date) {
                print(date);
              },
              selectTime: (TimeOfDay time) {
                print(time);
              },
            ),
            RaisedButton(
              onPressed: () {},
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).textTheme.headline.color,
            )
          ],
        ),
      ),
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  static final List<TimeOfDay> timeList = const [
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 10, minute: 30),
    TimeOfDay(hour: 11, minute: 0),
    TimeOfDay(hour: 11, minute: 30),
    TimeOfDay(hour: 12, minute: 0),
    TimeOfDay(hour: 12, minute: 30),
    TimeOfDay(hour: 13, minute: 0),
    TimeOfDay(hour: 13, minute: 30),
    TimeOfDay(hour: 14, minute: 0),
    TimeOfDay(hour: 14, minute: 30),
    TimeOfDay(hour: 15, minute: 0),
    TimeOfDay(hour: 15, minute: 30),
    TimeOfDay(hour: 16, minute: 0),
    TimeOfDay(hour: 16, minute: 30),
    TimeOfDay(hour: 17, minute: 0),
    TimeOfDay(hour: 17, minute: 30),
    TimeOfDay(hour: 18, minute: 0),
    TimeOfDay(hour: 18, minute: 30),
    TimeOfDay(hour: 19, minute: 0),
    TimeOfDay(hour: 19, minute: 30),
  ];

  const _DateTimePicker(
      {Key key,
      this.labelText,
      this.selectedDate,
      this.selectedTime,
      this.selectDate,
      this.selectTime})
      : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      selectableDayPredicate: (DateTime date) => date.isAfter(
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day - 1),
          ),
    );
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: _InputDropdown(
            labelText: labelText,
            valueText: DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          flex: 3,
          child: DropdownButton(
            style: valueStyle,
            value: selectedTime.format(context),
            items: timeList
                .map(
                  (TimeOfDay timeOfDay) => DropdownMenuItem(
                        child: Text(timeOfDay.format(context)),
                        value: timeOfDay.format(context),
                      ),
                )
                .toList(),
            onChanged: (value) {
              print(value);
            },
          ),
        ),
      ],
    );
  }
}
