import 'package:flutter/material.dart';
import 'package:only_kids/models/time_slot.dart';
import 'package:only_kids/services/calendar_service.dart';
import 'package:only_kids/utils/utils.dart';
import 'package:only_kids/widgets/date_picker.dart';
import 'package:only_kids/main.dart';
import 'package:only_kids/models/appointment.dart';
import 'package:only_kids/services/appointment_service.dart';
import 'package:only_kids/widgets/time_picker.dart';

enum AppointmentMode {
  create,
  edit,
  readonly,
}

class AppointmentPage extends StatefulWidget {
  AppointmentPage({
    Key key,
    this.appointment,
    this.mode,
  })  : assert(appointment != null || mode == AppointmentMode.create),
        super(key: key);

  final Appointment appointment;
  final AppointmentMode mode;

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final AppointmentService _appointmentService = getIt.get<AppointmentService>();
  final CalendarService _calendarService = getIt.get<CalendarService>();

  DateTime _selectedDate;
  TimeSlot _selectedTimeSlot;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.mode != AppointmentMode.create ? widget.appointment.dateTime : DateTime.now();
    _selectedTimeSlot = widget.appointment?.timeSlot;
  }

  String _getTitle() {
    switch (widget.mode) {
      case AppointmentMode.create:
        return 'New Appointment';
      case AppointmentMode.edit:
        return 'Edit Appointment';
      case AppointmentMode.readonly:
      default:
        return 'Appointment';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        actions: <Widget>[
          if (widget.mode != AppointmentMode.create)
            IconButton(
              icon: Icon(Icons.delete),
              tooltip: 'Delete',
              onPressed: _cancelAppointment,
            ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                DatePicker(
                  selectedDate: _selectedDate,
                  selectDate: (DateTime date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder<List<TimeSlot>>(
                      stream: _calendarService.getTimeSlots(_selectedDate),
                      builder: (context, snapshot) {
                        final timeSlots = snapshot.data;
                        return snapshot.hasData
                            ? TimePicker(
                                timeSlots: timeSlots,
                                selected: _selectedTimeSlot,
                                select: (TimeSlot time) {
                                  setState(() {
                                    _selectedTimeSlot = time;
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
              ],
            ),
          ),
          if (widget.mode != AppointmentMode.readonly)
            Material(
              elevation: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).bottomAppBarColor,
                ),
                child: ButtonBar(
                  children: <Widget>[
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).primaryTextTheme.button.color,
                      onPressed: canSubmit ? _save : null,
                      child: Text(widget.mode == AppointmentMode.edit ? 'Save' : 'Book'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool get canSubmit => _selectedDate != null && _selectedTimeSlot != null;

  Future<void> _save() async {
    final picked = fromDateAndTime(
      _selectedDate,
      _selectedTimeSlot.timeOfDay,
    );

    final confirmed = widget.mode == AppointmentMode.edit
        ? await _showDialog('Update appointment', 'New appointment date: ${dayDateTime(picked)}', 'OK')
        : await _showDialog('Create appointment', 'Add appointment on: ${dayDateTime(picked)}', 'OK');

    if (!confirmed) {
      return;
    }

    widget.mode == AppointmentMode.edit
        ? await _appointmentService.update(Appointment(
            id: widget.appointment.id,
            uid: widget.appointment.uid,
            username: widget.appointment.username,
            dateTime: picked,
          ))
        : await _appointmentService.addForCurrentUser(Appointment(dateTime: picked));

    Navigator.pop(context);
  }

  _cancelAppointment() async {
    final confirmed = widget.mode == AppointmentMode.edit
        ? await _showDialog(
            'Cancel Appointment',
            'Are you sure you want to cancel this appointment?',
            'Yes',
            'No',
          )
        : await _showDialog(
            'Remove Appointment',
            'Are you sure you want to remove this past appointment?',
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
