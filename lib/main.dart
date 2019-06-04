import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/counter_bloc.dart';
import 'blocs/nav_bar_bloc.dart';
import 'screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProviderTree(
          blocProviders: [
            BlocProvider<CounterBloc>(bloc: CounterBloc()),
            BlocProvider<NavBarBloc>(bloc: NavBarBloc()),
          ],
          child: MyHomePage(title: 'Only Kids'),
        ));
  }
}
