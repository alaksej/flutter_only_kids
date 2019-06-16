import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/nav_bar_bloc.dart';
import 'screens/home_page.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    analytics.logAppOpen();

    return MaterialApp(
        title: 'Only Kids',
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
          child: HomePage(title: 'Only Kids'),
        ));
  }
}
