import 'package:cloud_firestore/cloud_firestore.dart';
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
      child: ListView(
        children: <Widget>[
          _buildPageItems(context),
          _buildAppointments(context),
        ],
      ),
    );
  }

  Widget _buildAppointments(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('appointments').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          return Card(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    'My Appointments',
                    style: Theme.of(context).textTheme.headline,
                  ),
                ),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  margin: EdgeInsets.all(10.0),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 20.0),
                    children: snapshot.data.documents
                        .map((data) => _buildListItem(context, data))
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Container _buildPageItems(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
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
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
            title: Text(record.name),
            trailing: Text(record.datetime.toString()),
            onTap: () {
              print('Edit');
            }),
      ),
    );
  }
}

class Record {
  final String name;
  final DateTime datetime;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['datetime'] != null),
        name = map['name'],
        datetime = DateTime.fromMicrosecondsSinceEpoch(
            map['datetime'].microsecondsSinceEpoch);

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$datetime>";
}
