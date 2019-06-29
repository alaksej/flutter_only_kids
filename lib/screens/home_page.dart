import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:only_kids/components/appointments_list.dart';
import 'package:only_kids/components/top_app_bar.dart';
import 'package:only_kids/models/user_profile.dart';
import 'package:only_kids/screens/login_page.dart';
import 'package:only_kids/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import 'appointment_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key, this.title, this.analytics, this.observer}) : super(key: key);

  final String title;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  Widget build(BuildContext context) {
    final UserProfile _userProfile = Provider.of<UserProfile>(context);

    return Scaffold(
      appBar: TopAppBar(title: title),
      body: AppointmentsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _userProfile == null
              ? Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) => LoginPage(goToAppointmentAfterLogin: true)))
              : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AppointmentPage()));
          // analytics.setCurrentScreen(screenName: 'Appointment');
        },
        tooltip: 'Add an appointment',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
