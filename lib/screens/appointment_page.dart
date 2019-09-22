import 'package:flutter/material.dart';
import 'package:only_kids/localizations.dart';
import 'package:only_kids/models/time_slot.dart';
import 'package:only_kids/services/calendar_service.dart';
import 'package:only_kids/utils/utils.dart';
import 'package:only_kids/widgets/date_picker.dart';
import 'package:only_kids/main.dart';
import 'package:only_kids/models/appointment.dart';
import 'package:only_kids/services/appointment_service.dart';
import 'package:only_kids/widgets/overlay.dart';
import 'package:only_kids/widgets/spinner.dart';
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
  String get _comment => commentController.text;

  final commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.mode != AppointmentMode.create ? widget.appointment.dateTime : DateTime.now();
    _selectedTimeSlot = widget.appointment?.timeSlot;
    commentController.text = widget.appointment?.comment;
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  String _getTitle(BuildContext context) {
    OnlyKidsLocalizations l10ns = OnlyKidsLocalizations.of(context);
    switch (widget.mode) {
      case AppointmentMode.create:
        return l10ns.newAppointment;
      case AppointmentMode.edit:
        return l10ns.editAppointment;
      case AppointmentMode.readonly:
      default:
        return l10ns.pastAppointment;
    }
  }

  @override
  Widget build(BuildContext context) {
    final OnlyKidsLocalizations l10ns = OnlyKidsLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(context)),
        actions: <Widget>[
          if (widget.mode != AppointmentMode.create)
            IconButton(
              icon: Icon(Icons.delete),
              tooltip: OnlyKidsLocalizations.of(context).delete,
              onPressed: () => _cancelAppointment(context),
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
                      _selectedTimeSlot = null;
                    });
                  },
                  isReadonly: widget.mode == AppointmentMode.readonly,
                ),
                StreamBuilder<List<TimeSlot>>(
                  stream: _calendarService.getTimeSlots(_selectedDate),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Spinner();
                    }

                    final timeSlots = snapshot.data;
                    return timeSlots.any((slot) => slot.isSelectable) || widget.mode == AppointmentMode.readonly
                        ? _buildContentForDate(timeSlots)
                        : Center(
                            child: Text(
                              OnlyKidsLocalizations.of(context).timeslotsUnavailable,
                              textAlign: TextAlign.center,
                            ),
                          );
                  },
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
                      onPressed: canSubmit ? () => _save(context) : null,
                      child: Text(widget.mode == AppointmentMode.edit ? l10ns.save : l10ns.book),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContentForDate(List<TimeSlot> timeSlots) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TimePicker(
            timeSlots: timeSlots,
            selected: _selectedTimeSlot,
            select: (TimeSlot time) {
              setState(() {
                _selectedTimeSlot = time;
              });
            },
            isReadonly: widget.mode == AppointmentMode.readonly,
          ),
        ),
        SizedBox(height: 20.0),
        _buildComment(),
      ],
    );
  }

  Container _buildComment() {
    final OnlyKidsLocalizations l10ns = OnlyKidsLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: commentController,
        minLines: 1,
        maxLines: 5,
        readOnly: widget.mode == AppointmentMode.readonly,
        enabled: widget.mode != AppointmentMode.readonly,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: l10ns.comment,
          hintText: l10ns.writeComment,
        ),
      ),
    );
  }

  bool get canSubmit => _selectedDate != null && _selectedTimeSlot != null;

  Future<void> _save(BuildContext context) async {
    final OnlyKidsLocalizations l10ns = OnlyKidsLocalizations.of(context);
    assert(widget.mode != AppointmentMode.readonly);

    final picked = fromDateAndTime(
      _selectedDate,
      _selectedTimeSlot.timeOfDay,
    );

    final confirmed = widget.mode == AppointmentMode.edit
        ? await showConfirmationDialog(
            context,
            l10ns.editAppointment,
            l10ns.areYouSureToUpdate.replaceFirst(r'$date', dayDateTime(context, picked)),
            l10ns.ok,
            l10ns.close,
          )
        : await showConfirmationDialog(
            context,
            l10ns.createAppointment,
            l10ns.areYouSureToAdd.replaceFirst(r'$date', dayDateTime(context, picked)),
            l10ns.ok,
            l10ns.close,
          );

    if (!confirmed) {
      return;
    }

    final Appointment newAppointment = Appointment(
      id: widget.appointment?.id,
      uid: widget.appointment?.uid,
      username: widget.appointment?.username,
      dateTime: picked,
      comment: _comment,
    );

    widget.mode == AppointmentMode.edit
        ? await _appointmentService.update(newAppointment)
        : await _appointmentService.addForCurrentUser(newAppointment);

    Navigator.pop(context);

    showToast(l10ns.appointmentSaved);
  }

  _cancelAppointment(BuildContext context) async {
    final OnlyKidsLocalizations l10ns = OnlyKidsLocalizations.of(context);
    final confirmed = widget.mode == AppointmentMode.edit
        ? await showConfirmationDialog(
            context,
            l10ns.cancelAppointment,
            l10ns.areYouSureToCancel,
            l10ns.yes,
            l10ns.no,
          )
        : await showConfirmationDialog(
            context,
            l10ns.removeAppointment,
            l10ns.areYouSureToRemove,
            l10ns.yes,
            l10ns.no,
          );

    if (!confirmed) {
      return;
    }

    await _appointmentService.delete(widget.appointment.id);
    Navigator.pop(context);
    showToast(l10ns.appointmentRemoved);
  }
}
