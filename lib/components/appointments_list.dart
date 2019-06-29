import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:only_kids/main.dart';
import 'package:only_kids/models/appointment.dart';
import 'package:only_kids/services/appointment_service.dart';

class AppointmentsList extends StatelessWidget {
  final AppointmentService _appointmentService = getIt.get<AppointmentService>();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            child: Text(
              'My Appointments',
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            margin: EdgeInsets.all(10.0),
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
        ],
      ),
    );
  }

  ListView _buildAppointmentsList(List<Appointment> appointments, BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 20.0),
      children: appointments.map((data) => _buildAppointmentsListItem(context, data)).toList(),
    );
  }

  Widget _buildAppointmentsListItem(BuildContext context, Appointment appointment) {
    return Padding(
      key: ValueKey(appointment.username),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(appointment.username),
          trailing: Text(DateFormat.yMMMd().format(appointment.datetime)),
          onTap: () {
            print('Edit');
          },
        ),
      ),
    );
  }
}
