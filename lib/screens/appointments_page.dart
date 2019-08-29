import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:only_kids/models/appointment.dart';
import 'package:only_kids/services/appointment_service.dart';
import 'package:only_kids/services/auth_service.dart';
import 'package:only_kids/widgets/appointments_list.dart';
import 'package:only_kids/models/user_profile.dart';
import 'package:only_kids/screens/login_page.dart';
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

  @override
  Widget build(BuildContext context) {
    final UserProfile _userProfile = Provider.of<UserProfile>(context);
    final AuthService _authService = getIt.get<AuthService>();
    final isLoggedIn = _userProfile != null;
    final AppointmentService _appointmentService = getIt.get<AppointmentService>();

    return DefaultTabController(
      length: myTabs.length,
      child: StreamBuilder<bool>(
        stream: _authService.loading$,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                tabs: myTabs,
              ),
              title: Text('Appointments'),
              actions: !snapshot.hasData || snapshot.data
                  ? []
                  : isLoggedIn ? _buildUserActions(context, _authService, _userProfile) : _buildLogInActions(context),
            ),
            body: TabBarView(
              children: [
                _buildTab(
                  _userProfile,
                  _authService,
                  _appointmentService.getUpcomingAll(),
                  _appointmentService.getUpcomingByCurrentUser(),
                  'You have no upcoming appointments',
                  AppointmentMode.edit,
                ),
                _buildTab(
                  _userProfile,
                  _authService,
                  _appointmentService.getPastAll(),
                  _appointmentService.getPastByCurrentUser(),
                  'You have no past appointments',
                  AppointmentMode.readonly,
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _userProfile == null
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage(goToAppointmentAfterLogin: true),
                        ),
                      )
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
            ),
          );
        },
      ),
    );
  }

  StreamBuilder<Object> _buildTab(
    UserProfile _userProfile,
    AuthService _authService,
    Stream<List<Appointment>> appointmentsAll,
    Stream<List<Appointment>> appointmentsUser,
    String emptyMessage,
    AppointmentMode mode,
  ) {
    return _userProfile == null
        ? _buildLoginMessage(_authService)
        : _buildAppointmentsList(_userProfile.admin ? appointmentsAll : appointmentsUser, emptyMessage, mode);
  }

  StreamBuilder<List<Appointment>> _buildAppointmentsList(
    Stream<List<Appointment>> appointmentsStream,
    String emptyMessage,
    AppointmentMode mode,
  ) {
    return StreamBuilder<List<Appointment>>(
      stream: appointmentsStream,
      builder: (context, snapshot) => !snapshot.hasData
          ? Center(child: _buildCircularProgressIndicator(context))
          : AppointmentsList(snapshot.data, emptyMessage, mode),
    );
  }

  StreamBuilder<bool> _buildLoginMessage(AuthService _authService) {
    return StreamBuilder<bool>(
      stream: _authService.loading$,
      builder: (context, snapshot) => Center(
        child: !snapshot.hasData || snapshot.data
            ? _buildCircularProgressIndicator(context)
            : Text('Please log in to manage your appointments'),
      ),
    );
  }

  Widget _buildCircularProgressIndicator(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
    );
  }

  List<Widget> _buildUserActions(
    BuildContext context,
    AuthService authService,
    UserProfile user,
  ) {
    final List<Widget> widgets = <Widget>[];

    final List<String> placeholderCharSources = <String>[
      user.displayName,
      user.email,
      '-',
    ];
    final String placeholderChar = placeholderCharSources
        .firstWhere((String str) => str != null && str.trimLeft().isNotEmpty)
        .trimLeft()[0]
        .toUpperCase();
    if (user.photoUrl == null) {
      widgets.add(
        CircleAvatar(
          child: Text(placeholderChar),
        ),
      );
    }

    widgets.add(
      PopupMenuButton<_AppBarOverflowOptions>(
        onSelected: (_AppBarOverflowOptions selection) async {
          switch (selection) {
            case _AppBarOverflowOptions.signout:
              await authService.signOut();
              break;
            case _AppBarOverflowOptions.settings:
              print('settings');
              break;
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 15.0,
            child: Container(
              width: 30.0,
              height: 30.0,
              child: ClipOval(
                child: CachedNetworkImage(
                  placeholder: (context, url) => CircleAvatar(
                    child: Text(placeholderChar),
                  ),
                  imageUrl: user.photoUrl,
                ),
              ),
            ),
          ),
        ),
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry<_AppBarOverflowOptions>>[
            PopupMenuItem<_AppBarOverflowOptions>(
              value: _AppBarOverflowOptions.settings,
              child: const Text('Settings'),
            ),
            PopupMenuItem<_AppBarOverflowOptions>(
              value: _AppBarOverflowOptions.signout,
              child: const Text('Log Out'),
            ),
          ];
        },
      ),
    );

    return widgets;
  }

  List<Widget> _buildLogInActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.account_circle),
        tooltip: 'Log in',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => LoginPage(),
            ),
          );
        },
      )
    ];
  }
}

enum _AppBarOverflowOptions {
  signout,
  settings,
}
