import 'package:flutter/material.dart';
import 'package:only_kids/localizations.dart';

class Destination {
  const Destination(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final MaterialColor color;
}

List<Destination> getAllDestinations(BuildContext context) {
  final OnlyKidsLocalizations l10ns = OnlyKidsLocalizations.of(context)!;
  return <Destination>[
    Destination(l10ns.appointments, Icons.people, Colors.teal),
    Destination(l10ns.gallery, Icons.image, Colors.cyan),
    Destination(l10ns.contacts, Icons.location_on, Colors.orange),
  ];
}
