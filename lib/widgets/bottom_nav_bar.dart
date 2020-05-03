import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:only_kids/blocs/nav_bar_bloc.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NavBarBloc _navBarBloc = BlocProvider.of<NavBarBloc>(context);

    return BlocBuilder(
      bloc: _navBarBloc,
      builder: (BuildContext context, int currentIndex) {
        return BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.date_range),
              title: Text('Calendar'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              title: Text('Contacts'),
            ),
          ],
          currentIndex: _navBarBloc.state,
          selectedItemColor: Theme.of(context).accentColor,
          onTap: (index) {
            _navBarBloc.add(NavBarEvent(index));
          },
        );
      },
    );
  }
}
