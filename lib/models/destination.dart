import 'package:flutter/material.dart';

class Destination {
  const Destination(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final MaterialColor color;
}

const List<Destination> allDestinations = <Destination>[
  Destination('Appointments', Icons.people, Colors.teal),
  Destination('News', Icons.list, Colors.cyan),
  Destination('Contacts', Icons.location_on, Colors.orange),
];
