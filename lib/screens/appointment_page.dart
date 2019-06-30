import 'package:flutter/material.dart';
import 'package:only_kids/widgets/date_picker.dart';
import 'package:only_kids/main.dart';
import 'package:only_kids/models/appointment.dart';
import 'package:only_kids/services/appointment_service.dart';
import 'package:only_kids/widgets/time_picker.dart';

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
  final AppointmentService _appointmentService = getIt.get<AppointmentService>();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment'),
      ),
      body: Column(
        children: <Widget>[
          Text('Please select the date:', style: Theme.of(context).textTheme.subhead),
          DatePicker(
            selectedDate: _selectedDate,
            selectDate: (DateTime date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),
          Text('Please select the time:', style: Theme.of(context).textTheme.subhead),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TimePicker(
                timeSlots: timeSlots,
                selectedTime: _selectedTime,
                selectTime: (TimeOfDay time) {
                  setState(() {
                    _selectedTime = time;
                  });
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryTextTheme.button.color,
                  onPressed: canSubmit ? _submitAppointment : null,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool get canSubmit => _selectedDate != null && _selectedTime != null;

  Future<void> _submitAppointment() async {
    final picked = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    await _appointmentService.addForCurrentUser(Appointment(datetime: picked));

    Navigator.pop(context);
  }
}
