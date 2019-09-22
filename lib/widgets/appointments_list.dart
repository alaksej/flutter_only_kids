import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:only_kids/models/appointment.dart';
import 'package:only_kids/models/user_profile.dart';
import 'package:only_kids/screens/appointment_page.dart';
import 'package:only_kids/utils/utils.dart';
import 'package:provider/provider.dart';

class AppointmentsList extends StatelessWidget {
  AppointmentsList(this._appointments, this._emptyMessage, this.mode);
  
  final List<Appointment> _appointments;
  final String _emptyMessage;
  final AppointmentMode mode;

  @override
  Widget build(BuildContext context) {
    final UserProfile _userProfile = Provider.of<UserProfile>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(child: _buildAppointmentsList(_appointments, context, _userProfile.admin)),
      ],
    );
  }

  Widget _buildAppointmentsList(List<Appointment> appointments, BuildContext context, bool admin) {
    if (appointments.length == 0) {
      return Center(child: Text(_emptyMessage, style: Theme.of(context).textTheme.subhead));
    }
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: appointments.map((appointment) => _buildAppointmentsListItem(context, appointment, admin)).toList(),
    );
  }

  Widget _buildAppointmentsListItem(BuildContext context, Appointment appointment, bool admin) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                capitalize(localizations.formatFullDate(appointment.dateTime)),
                style: Theme.of(context).textTheme.subhead,
              ),
              SizedBox(height: 5.0),
              Text(
                localizations.formatTimeOfDay(TimeOfDay.fromDateTime(appointment.dateTime)),
                style: Theme.of(context).textTheme.subtitle,
              ),
              if (admin) ...[
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 15.0,
                    ),
                    SizedBox(width: 5.0),
                    Text(appointment.username, style: Theme.of(context).textTheme.subtitle),
                  ],
                ),
              ]
            ],
          ),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => AppointmentPage(appointment: appointment, mode: mode),
              ),
            );
          },
        ),
      ),
    );
  }
}
