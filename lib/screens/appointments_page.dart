import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:only_kids/models/appointment.dart';
import 'package:only_kids/screens/profile_page.dart';
import 'package:only_kids/services/appointment_service.dart';
import 'package:only_kids/services/auth_service.dart';
import 'package:only_kids/services/loading_service.dart';
import 'package:only_kids/widgets/appointments_list.dart';
import 'package:only_kids/models/user_profile.dart';
import 'package:only_kids/screens/login_page.dart';
import 'package:only_kids/widgets/avatar.dart';
import 'package:only_kids/widgets/spinner.dart';
import 'package:provider/provider.dart';
import 'package:only_kids/main.dart';

import 'appointment_page.dart';

class AppointmentsPage extends StatelessWidget {
  AppointmentsPage({Key key, this.analytics, this.observer}) : super(key: key);
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'UPCOMING'),
    Tab(text: 'PAST'),
  ];

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final LoadingService loadingService = getIt.get<LoadingService>();
  final AuthService authService = getIt.get<AuthService>();
  final AppointmentService appointmentService = getIt.get<AppointmentService>();

  @override
  Widget build(BuildContext context) {
    final UserProfile userProfile = Provider.of<UserProfile>(context);
    final bool isLoggedIn = userProfile != null;

    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
            appBar: AppBar(
              bottom: isLoggedIn
                  ? TabBar(
                      tabs: myTabs,
                    )
                  : null,
              title: Text('Appointments'),
          actions: isLoggedIn ? _buildUserActions(context, userProfile) : _buildLogInActions(context),
            ),
            body: !isLoggedIn
                ? _buildLoginMessage()
                : TabBarView(
                    children: [
                      _buildTab(
                        userProfile,
                        appointmentService.getUpcomingAll(),
                        appointmentService.getUpcomingByCurrentUser(),
                        'You have no upcoming appointments',
                        AppointmentMode.edit,
                      ),
                      _buildTab(
                        userProfile,
                        appointmentService.getPastAll(),
                        appointmentService.getPastByCurrentUser(),
                        'You have no past appointments',
                        AppointmentMode.readonly,
                      ),
                    ],
                  ),
            floatingActionButton: isLoggedIn
                ? FloatingActionButton(
                    onPressed: () {
                      !isLoggedIn
                          ? _redirectToLoginPage(context)
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => AppointmentPage(mode: AppointmentMode.create),
                              ),
                            );
                      // analytics.setCurrentScreen(screenName: 'Appointment');
                    },
                    tooltip: 'Add an appointment',
                    child: Icon(Icons.add),
                  )
                : null,
      ),
    );
  }

  Future _redirectToLoginPage(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LoginPage(),
      ),
    );
  }

  Future _redirectToProfilePage(
    BuildContext context,
    UserProfile userProfile,
  ) {
    return Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ProfilePage()));
  }

  StreamBuilder<Object> _buildTab(
    UserProfile _userProfile,
    Stream<List<Appointment>> appointmentsAll,
    Stream<List<Appointment>> appointmentsUser,
    String emptyMessage,
    AppointmentMode mode,
  ) {
    return _buildAppointmentsList(_userProfile.admin ? appointmentsAll : appointmentsUser, emptyMessage, mode);
  }

  StreamBuilder<List<Appointment>> _buildAppointmentsList(
    Stream<List<Appointment>> appointmentsStream,
    String emptyMessage,
    AppointmentMode mode,
  ) {
    return StreamBuilder<List<Appointment>>(
      stream: appointmentsStream,
      builder: (context, snapshot) =>
          !snapshot.hasData ? Spinner() : AppointmentsList(snapshot.data, emptyMessage, mode),
    );
  }

  StreamBuilder<bool> _buildLoginMessage() {
    return StreamBuilder<bool>(
      stream: loadingService.loading$,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data) {
          return Spinner();
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Please log in to manage your appointments'),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).primaryTextTheme.button.color,
                onPressed: () {
                  _redirectToLoginPage(context);
                },
                child: Text('Log in'),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildUserActions(
    BuildContext context,
    UserProfile userProfile,
  ) {
    final double avatarSize = 30.0;

    return <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Avatar(
          avatarSize: avatarSize,
          userProfile: userProfile,
          onTap: (context) => _redirectToProfilePage(context, userProfile),
        ),
      ),
    ];
  }

  List<Widget> _buildLogInActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.account_circle),
        tooltip: 'Log in',
        onPressed: () {
          _redirectToLoginPage(context);
        },
      )
    ];
  }
}
