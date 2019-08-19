import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:only_kids/models/destination.dart';
import 'package:only_kids/models/user_profile.dart';
import 'package:only_kids/screens/destination_view.dart';
import 'package:only_kids/services/appointment_service.dart';
import 'package:only_kids/services/calendar_service.dart';
import 'package:only_kids/services/auth_service.dart';

import 'blocs/nav_bar_bloc.dart';
import 'screens/appointments_page.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt();

void main() {
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<AppointmentService>(AppointmentService());
  getIt.registerSingleton<CalendarService>(CalendarService());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Color primaryColor = Colors.blue;
  final Color accentColor = Colors.pink;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    MyApp.analytics.logAppOpen();

    final appTitle = 'Only Kids';

    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
          value: getIt.get<AuthService>().user$,
        ),
        StreamProvider<UserProfile>.value(
          value: getIt.get<AuthService>().userProfile$,
        ),
      ],
      child: MaterialApp(
        title: appTitle,
        theme: ThemeData(
          primarySwatch: primaryColor,
          accentColor: accentColor,
        ),
        navigatorObservers: <NavigatorObserver>[MyApp.observer],
        home: BlocProviderTree(
          blocProviders: [
            BlocProvider<NavBarBloc>(
              builder: (BuildContext context) => NavBarBloc(),
            ),
          ],
          child: Scaffold(
            body: SafeArea(
              top: false,
              child: IndexedStack(
                index: _currentIndex,
                children: <Widget>[
                  AppointmentsPage(),
                  DestinationView(
                    destination: allDestinations[1],
                  ),
                  DestinationView(
                    destination: allDestinations[2],
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: allDestinations.map((Destination destination) {
                return BottomNavigationBarItem(
                  icon: Icon(destination.icon),
                  title: Text(destination.title),
                );
              }).toList(),
              selectedItemColor: Colors.pink,
            ),
          ),
        ),
      ),
    );
  }
}
