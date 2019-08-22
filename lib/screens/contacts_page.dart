import 'package:flutter/material.dart';
import 'package:only_kids/screens/contacts_contents_page.dart';
import 'package:only_kids/screens/map_page.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  return ContactsContentsPage();
                case '/map':
                  return MapPage();
              }
            },
          );
        },
      ),
    );
  }
}
