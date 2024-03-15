import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:only_kids/models/destination.dart';
import 'package:only_kids/models/user_profile.dart';
import 'package:only_kids/screens/contacts_page.dart';
import 'package:only_kids/screens/gallery_page.dart';
import 'package:only_kids/services/appointment_service.dart';
import 'package:only_kids/services/calendar_service.dart';
import 'package:only_kids/services/auth_service.dart';
import 'package:only_kids/services/hairstyles_service.dart';
import 'package:overlay_support/overlay_support.dart';

import 'blocs/nav_bar_bloc.dart';
import 'localizations.dart';
import 'screens/appointments_page.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

import 'services/cloud_functions_service.dart';
import 'services/loading_service.dart';

GetIt getIt = GetIt.instance;

void registerServiceProviders() {
  getIt.registerSingleton<LoadingService>(LoadingService());
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<AppointmentService>(AppointmentService());
  getIt.registerSingleton<CalendarService>(CalendarService());
  getIt.registerSingleton<HairstylesService>(HairstylesService());
  getIt.registerSingleton<CloudFunctionsService>(CloudFunctionsService());
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  registerServiceProviders();
  runApp(OnlyKidsApp());
}

class OnlyKidsApp extends StatefulWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  _OnlyKidsAppState createState() => _OnlyKidsAppState();
}

class _OnlyKidsAppState extends State<OnlyKidsApp> {
  final MaterialColor primaryColor = Colors.blue;
  final MaterialColor accentColor = Colors.pink;

  @override
  Widget build(BuildContext context) {
    OnlyKidsApp.analytics.logAppOpen();

    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          value: getIt.get<AuthService>().firebaseUser$,
          initialData: null,
        ),
        StreamProvider<UserProfile?>.value(
          value: getIt.get<AuthService>().userProfile$,
          initialData: null,
        ),
      ],
      child: OverlaySupport(
        child: MaterialApp(
          onGenerateTitle: (BuildContext context) => OnlyKidsLocalizations.of(context)!.title,
          localizationsDelegates: [
            const OnlyKidsLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', ''),
            const Locale('ru', ''),
          ],
          theme: ThemeData(
            primarySwatch: primaryColor,
          ),
          navigatorObservers: <NavigatorObserver>[OnlyKidsApp.observer],
          home: MultiBlocProvider(
            providers: [
              BlocProvider<NavBarBloc>(
                create: (BuildContext context) => NavBarBloc(0),
              ),
            ],
            child: new MaterialAppChild(),
          ),
        ),
      ),
    );
  }
}

class MaterialAppChild extends StatefulWidget {
  @override
  _MaterialAppChildState createState() => _MaterialAppChildState();
}

class _MaterialAppChildState extends State<MaterialAppChild> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _currentIndex,
          children: <Widget>[
            AppointmentsPage(),
            GalleryPage(),
            ContactsPage(),
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
        items: getAllDestinations(context).map((Destination destination) {
          return BottomNavigationBarItem(
            icon: Icon(destination.icon),
            label: destination.title,
          );
        }).toList(),
        selectedItemColor: Colors.pink,
      ),
    );
  }
}
