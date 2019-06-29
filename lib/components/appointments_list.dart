import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:only_kids/main.dart';
import 'package:only_kids/models/appointment.dart';
import 'package:only_kids/models/user_profile.dart';
import 'package:only_kids/services/appointment_service.dart';
import 'package:provider/provider.dart';

class AppointmentsList extends StatelessWidget {
  final AppointmentService _appointmentService = getIt.get<AppointmentService>();

  @override
  Widget build(BuildContext context) {
    final UserProfile _userProfile = Provider.of<UserProfile>(context);

    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            'My Appointments',
            style: Theme.of(context).textTheme.headline,
          ),
        ),
        if (_userProfile != null)
          Expanded(
            child: StreamBuilder<List<Appointment>>(
              stream: _appointmentService.getByCurrentUser(),
              builder: (context, snapshot) => !snapshot.hasData
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                      ),
                    )
                  : _buildAppointmentsList(snapshot.data, context),
            ),
          ),
        if (_userProfile == null)
          Center(
            child: Text('Please log in to manage your appointments'),
          )
      ],
    );
  }

  ListView _buildAppointmentsList(List<Appointment> appointments, BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 20.0),
      separatorBuilder: (context, index) => Divider(height: 1),
      itemCount: appointments.length,
      itemBuilder: (context, index) => _buildAppointmentsListItem(context, appointments[index]),
    );
  }

  Widget _buildAppointmentsListItem(BuildContext context, Appointment appointment) {
    return Padding(
      key: ValueKey(appointment.username),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              DateFormat.yMMMd().format(appointment.datetime),
              style: Theme.of(context).textTheme.body2,
            ),
            trailing: Icon(Icons.edit),
            onTap: () {
              print('Edit');
            },
          ),
        ],
      ),
    );
  }
}
