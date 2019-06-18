import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final List<TimeOfDay> timeSlots = const [
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

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = timeSlots[0];
  TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment'),
      ),
      body: Column(
        children: <Widget>[
          _DatePicker(
            selectedDate: _selectedDate,
            selectDate: (DateTime date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),
          TextField(
            controller: _textEditingController,
          ),
          RaisedButton(
            onPressed: () {
              _submitAppointment();
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitAppointment() async {
    final picked = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    final String name = _textEditingController.text;
    print('Creating appointment for $name on $picked');
    await Firestore.instance
        .collection('appointments')
        .document()
        .setData({'name': name, 'datetime': picked});
    Navigator.pop(context);
  }
}

class _DatePicker extends StatelessWidget {
  const _DatePicker({
    Key key,
    this.selectedDate,
    this.selectDate,
  }) : super(key: key);

  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2019),
      lastDate: DateTime(2101),
      selectableDayPredicate: (DateTime date) => date.isAfter(
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day - 1),
          ),
    );
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        // decoration: BoxDecoration(color: Theme.of(context).colorScheme.background),
        height: 80,
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
    );
  }
}
