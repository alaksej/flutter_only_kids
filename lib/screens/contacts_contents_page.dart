import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ContactsContentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Only Kids Gomel',
                style: Theme.of(context).textTheme.headline,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.location_on),
                title: Text('Ulitsa Rogachovskaya 2a, Homieĺ 246000'),
                trailing: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/map');
                  },
                  child: SvgPicture.asset(
                    'assets/google_maps.svg',
                    height: 30.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.phone),
                title: Text('+375 29 137-20-65'),
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
