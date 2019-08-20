import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ContactsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: ListView(
          children: <Widget>[
            Text(
              'Only Kids Gomel',
              style: Theme.of(context).textTheme.headline,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.location_on),
                title: Text('Ulitsa Rogachovskaya 2a, Homieĺ 246000'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: SvgPicture.asset(
                  'assets/instagram.svg',
                  height: 30.0,
                ),
                title: Text('Instagram'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
