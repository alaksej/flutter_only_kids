import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:only_kids/models/user_profile.dart';
import 'package:only_kids/services/appointment_service.dart';
import 'package:only_kids/services/calendar_service.dart';
import 'package:only_kids/services/auth_service.dart';

import 'blocs/nav_bar_bloc.dart';
import 'screens/home_page.dart';

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

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    analytics.logAppOpen();

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
          primarySwatch: Colors.blue,
          accentColor: Colors.pink,
        ),
        navigatorObservers: <NavigatorObserver>[observer],
        home: BlocProviderTree(
          blocProviders: [
            BlocProvider<NavBarBloc>(
              builder: (BuildContext context) => NavBarBloc(),
            ),
          ],
          child: HomePage(title: appTitle),
        ),
      ),
    );
  }
}
