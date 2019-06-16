import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:only_kids/screens/about_page.dart';
import 'package:only_kids/screens/services_page.dart';
import 'package:only_kids/screens/team_page.dart';
import 'package:only_kids/widgets/bottom_nav_bar.dart';

import 'appointment_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.analytics, this.observer})
      : super(key: key);

  final String title;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _HomePageState createState() => _HomePageState(analytics, observer);
}

class _HomePageState extends State<HomePage> {
  _HomePageState(this.analytics, this.observer);

  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            tooltip: 'Air it',
            onPressed: () {},
          ),
        ],
      ),
      body: _HomeBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AppointmentPage()));
          analytics.setCurrentScreen(screenName: 'Appointment');
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2), BlendMode.dstATop),
        ),
      ),
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
              // color: Theme.of(context).canvasColor,
              ),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text('Services'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ServicesPage()));
                  },
                ),
                Divider(height: 1.0),
                ListTile(
                  title: Text('Our Team'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => TeamPage()));
                  },
                ),
                Divider(height: 1.0),
                ListTile(
                  title: Text('About Us'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => AboutPage()));
                  },
                ),
                Divider(height: 1.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
