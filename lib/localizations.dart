// This file was generated in two steps, using the Dart intl tools. With the
// app's root directory (the one that contains pubspec.yaml) as the current
// directory:
//
// flutter pub get
// flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/localizations.dart
// flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/localizations.dart lib/l10n/intl_*.arb
//
// The second command generates intl_messages.arb and the third generates
// messages_all.dart. There's more about this process in
// https://pub.dev/packages/intl.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'l10n/messages_all.dart';

class OnlyKidsLocalizations {
  OnlyKidsLocalizations(this.localeName);

  static Future<OnlyKidsLocalizations> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      return OnlyKidsLocalizations(localeName);
    });
  }

  static OnlyKidsLocalizations of(BuildContext context) {
    return Localizations.of<OnlyKidsLocalizations>(context, OnlyKidsLocalizations);
  }

  final String localeName;

  String get title {
    return Intl.message(
      'Only Kids',
      name: 'title',
      desc: 'Title for the OnlyKids application',
      locale: localeName,
    );
  }

  String appointments() {
    return Intl.message(
      'Appointments',
      name: 'appointments',
      desc: 'Title for the Appointments bottom bar item',
      locale: localeName,
    );
  }

  String contacts() {
    return Intl.message(
      'Contacts',
      name: 'contacts',
      desc: 'Title for the Contacts bottom bar item',
      locale: localeName,
    );
  }

  String gallery() {
    return Intl.message(
      'Gallery',
      name: 'gallery',
      desc: 'Title for the Gallery bottom bar item',
      locale: localeName,
    );
  }
}

class OnlyKidsLocalizationsDelegate extends LocalizationsDelegate<OnlyKidsLocalizations> {
  const OnlyKidsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ru'].contains(locale.languageCode);

  @override
  Future<OnlyKidsLocalizations> load(Locale locale) => OnlyKidsLocalizations.load(locale);

  @override
  bool shouldReload(OnlyKidsLocalizationsDelegate old) => false;
}
