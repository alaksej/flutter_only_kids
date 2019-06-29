import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:only_kids/services/auth_service.dart';
import 'package:only_kids/services/user_service.dart';

import 'blocs/nav_bar_bloc.dart';
import 'screens/home_page.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    analytics.logAppOpen();

    return MultiProvider(
      providers: [
        Provider<UserService>.value(value: new UserService()),
        Provider<AuthService>.value(value: new AuthService()),
      ],
      child: MaterialApp(
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
        ),
      ),
    );
  }
}
