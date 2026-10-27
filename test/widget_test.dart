import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frm_app/navigation.dart';

void main() {
  void setPhoneViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(430, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('bottom navigation reaches Home, Appointments, and Profile', (
    tester,
  ) async {
    setPhoneViewport(tester);
    await tester.pumpWidget(const MyApp());

    expect(find.text('How can we help you today?'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.event_available_outlined));
    await tester.pumpAndSettle();
    expect(find.text('My Appointments'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.person_outline_rounded));
    await tester.pumpAndSettle();
    expect(find.text('My Profile'), findsOneWidget);

    await tester.tap(find.byKey(const Key('profile-back-button')));
    await tester.pumpAndSettle();
    expect(find.text('How can we help you today?'), findsOneWidget);
  });

  testWidgets('Home appointment service card opens Appointments', (
    tester,
  ) async {
    setPhoneViewport(tester);
    await tester.pumpWidget(const MyApp());

    final card = find.byKey(const Key('service-card-myAppointments'));
    await tester.tap(card);
    await tester.pumpAndSettle();

    expect(find.text('My Appointments'), findsOneWidget);
  });
}
