import 'package:flutter/material.dart';
import 'package:only_kids/localizations.dart';

class Destination {
  const Destination(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final MaterialColor color;
}

List<Destination> getAllDestinations(BuildContext context) {
  OnlyKidsLocalizations l10n = OnlyKidsLocalizations.of(context);
  return <Destination>[
    Destination(l10n.appointments(), Icons.people, Colors.teal),
    Destination(l10n.gallery(), Icons.image, Colors.cyan),
    Destination(l10n.contacts(), Icons.location_on, Colors.orange),
  ];
}
