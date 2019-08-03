import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:only_kids/main.dart';
import 'package:only_kids/models/appointment.dart';
import 'package:only_kids/models/user_profile.dart';
import 'package:only_kids/screens/appointment_page.dart';
import 'package:only_kids/services/appointment_service.dart';
import 'package:only_kids/services/auth_service.dart';
import 'package:only_kids/utils/utils.dart';
import 'package:provider/provider.dart';

class AppointmentsList extends StatelessWidget {
  final AppointmentService _appointmentService = getIt.get<AppointmentService>();
  final AuthService _authService = getIt.get<AuthService>();

  @override
  Widget build(BuildContext context) {
    final UserProfile _userProfile = Provider.of<UserProfile>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (_userProfile != null)
          Expanded(
            child: StreamBuilder<List<Appointment>>(
              stream: _userProfile.admin ? _appointmentService.getAll() : _appointmentService.getByCurrentUser(),
              builder: (context, snapshot) => !snapshot.hasData
                  ? Center(child: _buildCircularProgressIndicator(context))
                  : _buildAppointmentsList(snapshot.data, context, _userProfile.admin),
            ),
          ),
        if (_userProfile == null)
          StreamBuilder<bool>(
            stream: _authService.loading$,
            builder: (context, snapshot) => Center(
              child: !snapshot.hasData || snapshot.data
                  ? _buildCircularProgressIndicator(context)
                  : Text('Please log in to manage your appointments'),
            ),
          ),
      ],
    );
  }

  Widget _buildCircularProgressIndicator(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
    );
  }

  Widget _buildAppointmentsList(List<Appointment> appointments, BuildContext context, bool admin) {
    if (appointments.length == 0) {
      return Text('You have no upcoming appointments', style: Theme.of(context).textTheme.subhead);
    }
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: appointments.map((appointment) => _buildAppointmentsListItem(context, appointment, admin)).toList(),
    );
  }

  Widget _buildAppointmentsListItem(BuildContext context, Appointment appointment, bool admin) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                dayDate(appointment.datetime),
                style: Theme.of(context).textTheme.subhead,
              ),
              SizedBox(height: 5.0),
              Text(
                time(appointment.datetime),
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
                builder: (BuildContext context) => AppointmentPage(appointment: appointment),
              ),
            );
          },
        ),
      ),
    );
  }
}
