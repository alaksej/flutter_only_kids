import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:only_kids/localizations.dart';
import 'package:only_kids/screens/map_page.dart';
import 'package:url_launcher/url_launcher.dart';

const phoneDisplay = '+375 29 137 20 65';
const phoneAndroid = 'tel:+375 29 137 20 65';
const phoneIOS = 'tel:00375291372065';
const website = 'https://onlykids.by';
const instagram = 'https://www.instagram.com/only_kids_gomel';

class ContactsContentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    final OnlyKidsLocalizations l10ns = OnlyKidsLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10ns.onlyKidsGomel),
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
                  title: Text(l10ns.address),
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
                  title: Text(phoneDisplay),
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
                  title: Text(website),
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
                      _buildWorkDay(l10ns.monday, '10:00 - 20:00'),
                      _buildWorkDay(l10ns.tuesday, '10:00 - 20:00'),
                      _buildWorkDay(l10ns.wednesday, '10:00 - 20:00'),
                      _buildWorkDay(l10ns.thursday, '10:00 - 20:00'),
                      _buildWorkDay(l10ns.friday, '10:00 - 20:00'),
                      _buildWorkDay(l10ns.saturday, '10:00 - 20:00'),
                      _buildWorkDay(l10ns.sunday, '10:00 - 20:00'),
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
    const uri = phoneAndroid;
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      const uri = phoneIOS;
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }

  _openInstagram() async {
    const url = instagram;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _openWebsite() async {
    const url = website;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
