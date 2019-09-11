import 'package:flutter_test/flutter_test.dart';

import 'package:only_kids/main.dart';
import 'package:only_kids/screens/appointments_page.dart';
import 'package:only_kids/screens/contacts_page.dart';
import 'package:only_kids/screens/gallery_page.dart';

void main() {
  testWidgets('Has widgets for the three pages', (WidgetTester tester) async {
    registerServiceProviders();

    // Build our app and trigger a frame.
    await tester.pumpWidget(OnlyKidsApp());

    expect(find.byType(AppointmentsPage), findsOneWidget);
    expect(find.byType(GalleryPage), findsOneWidget);
    expect(find.byType(ContactsPage), findsOneWidget);
  });
}
