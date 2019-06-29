import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:only_kids/components/top_app_bar.dart';
import 'package:only_kids/models/appointment.dart';
import 'package:only_kids/services/appointment_service.dart';
import 'package:only_kids/widgets/bottom_nav_bar.dart';

import '../main.dart';
import 'appointment_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.analytics, this.observer}) : super(key: key);

  final String title;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _HomePageState createState() => _HomePageState(analytics, observer);
}

class _HomePageState extends State<HomePage> {
  _HomePageState(this.analytics, this.observer);

  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(title: widget.title),
      body: _HomeBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AppointmentPage()));
          // analytics.setCurrentScreen(screenName: 'Appointment');
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  final AppointmentService _appointmentService = getIt.get<AppointmentService>();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
        ),
      ),
      child: ListView(
        children: <Widget>[
          _buildAppointments(context),
        ],
      ),
    );
  }

  Widget _buildAppointments(BuildContext context) {
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

  Widget _buildAppointmentsListItem(BuildContext context, appointment) {
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
            trailing: Text(appointment.datetime.toString()),
            onTap: () {
              print('Edit');
            }),
      ),
    );
  }
}
