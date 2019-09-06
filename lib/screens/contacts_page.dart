import 'package:flutter/material.dart';
import 'package:only_kids/screens/contacts_contents_page.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContactsContentsPage(),
    );
  }
}
