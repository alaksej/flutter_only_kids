import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:only_kids/screens/map_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsContentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text('Only Kids Gomel'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => MapPage(),
                    ),
                  );
                },
                child: ListTile(
                  title: Text('Ulitsa Rogachovskaya 2a, Homieĺ 246000'),
                  leading: Icon(
                    Icons.location_on,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
            Divider(height: 1.0),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: InkWell(
                onTap: _callUs,
                child: ListTile(
                  leading: Icon(
                    Icons.phone,
                    color: primaryColor,
                  ),
                  title: Text('+375 29 137-20-65'),
                ),
              ),
            ),
            Divider(height: 1.0),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: InkWell(
                onTap: _openInstagram,
                child: ListTile(
                  leading: SvgPicture.asset(
                    'assets/instagram.svg',
                    height: 25.0,
                    color: primaryColor,
                  ),
                  title: Text('only_kids_gomel'),
                ),
              ),
            ),
            Divider(height: 1.0),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: InkWell(
                onTap: _openWebsite,
                child: ListTile(
                  leading: Icon(
                    Icons.public,
                    color: primaryColor,
                  ),
                  title: Text('https://onlykids.by'),
                ),
              ),
            ),
            Divider(height: 1.0),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: ListTile(
                leading: Icon(
                  Icons.access_time,
                  color: primaryColor,
                ),
                title: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: <Widget>[
                      _buildWorkDay('Monday', '10:00 - 20:00'),
                      _buildWorkDay('Tuesday', '10:00 - 20:00'),
                      _buildWorkDay('Wednesday', '10:00 - 20:00'),
                      _buildWorkDay('Thursday', '10:00 - 20:00'),
                      _buildWorkDay('Friday', '10:00 - 20:00'),
                      _buildWorkDay('Saturday', '10:00 - 20:00'),
                      _buildWorkDay('Sunday', '10:00 - 20:00'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkDay(String day, String hours) {
    return Container(
      padding: EdgeInsets.only(
        top: 2.0,
        right: 10.0,
        bottom: 2.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(day),
          Text(hours),
        ],
      ),
    );
  }

  _callUs() async {
    // Android
    const uri = 'tel:+375 29 137 20 65';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      const uri = 'tel:00375291372065';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }

  _openInstagram() async {
    const url = 'https://www.instagram.com/only_kids_gomel';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _openWebsite() async {
    const url = 'https://onlykids.by';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
