import 'package:flutter/material.dart';
import 'package:only_kids/models/user_profile.dart';
import 'package:only_kids/services/calendar_service.dart';
import 'package:only_kids/utils/utils.dart';
import 'package:only_kids/widgets/date_picker.dart';
import 'package:only_kids/main.dart';
import 'package:only_kids/models/appointment.dart';
import 'package:only_kids/services/appointment_service.dart';
import 'package:only_kids/widgets/time_picker.dart';
import 'package:provider/provider.dart';

class AppointmentPage extends StatefulWidget {
  AppointmentPage({
    Key key,
    this.appointment,
  })  : isEditMode = appointment != null,
        super(key: key);

  final Appointment appointment;
  final bool isEditMode;

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final AppointmentService _appointmentService = getIt.get<AppointmentService>();
  final CalendarService _calendarService = getIt.get<CalendarService>();

  DateTime _selectedDate;
  TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.isEditMode ? widget.appointment.datetime : DateTime.now();
    _selectedTime = widget.appointment?.time;
  }

  @override
  Widget build(BuildContext context) {
    final UserProfile _userProfile = Provider.of<UserProfile>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditMode ? 'Edit Appointment' : 'New Appointment'),
        actions: <Widget>[
          if (widget.isEditMode)
            IconButton(
              icon: Icon(Icons.delete),
              tooltip: 'Cancel',
              onPressed: _cancelAppointment,
            ),
        ],
      ),
      body: Column(
        children: <Widget>[
          if (_userProfile.admin)
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 30.0,
                  ),
                  SizedBox(width: 10.0),
                  Text(widget.appointment?.username ?? '', style: Theme.of(context).textTheme.headline),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Please select the date:', style: Theme.of(context).textTheme.subhead),
          ),
          DatePicker(
            selectedDate: _selectedDate,
            selectDate: (DateTime date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Please select the time:', style: Theme.of(context).textTheme.subhead),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<List<TimeOfDay>>(
                  stream: _calendarService.getTimeSlots(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? TimePicker( 
                            timeSlots: snapshot.data,
                            selectedTime: _selectedTime,
                            selectTime: (TimeOfDay time) {
                              setState(() {
                                _selectedTime = time;
                              });
                            },
                          )
                        : Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                            ),
                          );
                  }),
            ),
          ),
          ButtonBar(
            children: <Widget>[
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).primaryTextTheme.button.color,
                onPressed: canSubmit ? _save : null,
                child: Text(widget.isEditMode ? 'Save' : 'Book'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool get canSubmit => _selectedDate != null && _selectedTime != null;

  Future<void> _save() async {
    final picked = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final confirmed = widget.isEditMode
        ? await _showDialog('Update appointment', 'New appointment date: ${dayDateTime(picked)}', 'OK')
        : await _showDialog('Create appointment', 'Add appointment on: ${dayDateTime(picked)}', 'OK');

    if (!confirmed) {
      return;
    }

    widget.isEditMode
        ? await _appointmentService.update(Appointment(
            id: widget.appointment.id,
            uid: widget.appointment.uid,
            username: widget.appointment.username,
            datetime: picked,
          ))
        : await _appointmentService.addForCurrentUser(Appointment(datetime: picked));

    Navigator.pop(context);
  }

  _cancelAppointment() async {
    final confirmed = await _showDialog(
      'Cancel Appointment',
      'Are you sure you want to cancel this appointment?',
      'Yes',
      'No',
    );

    if (!confirmed) {
      return;
    }

    await _appointmentService.delete(widget.appointment.id);
    Navigator.pop(context);
  }

  Future<bool> _showDialog(String title, String content, String confirmButton, [String closeButtton = 'Close']) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            new FlatButton(
              child: new Text(closeButtton.toUpperCase()),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            new FlatButton(
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
}
