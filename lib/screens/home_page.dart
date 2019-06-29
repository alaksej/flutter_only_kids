import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:only_kids/components/appointments_list.dart';
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
  @override
  Widget build(BuildContext context) {
    return AppointmentsList();
  }
}
