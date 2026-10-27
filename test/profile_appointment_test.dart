import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frm_app/models/appointment.dart';
import 'package:frm_app/screens/appointments_screen.dart';
import 'package:frm_app/screens/profile_screen.dart';

void main() {
  Widget buildTestApp(Widget home) {
    return MaterialApp(theme: ThemeData(useMaterial3: true), home: home);
  }

  void setPhoneViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(430, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('profile renders, validates edits, and saves local changes', (
    tester,
  ) async {
    setPhoneViewport(tester);
    await tester.pumpWidget(buildTestApp(const ProfileScreen()));

    expect(find.text('My Profile'), findsOneWidget);
    expect(find.text('Demo User'), findsWidgets);

    await tester.tap(find.byKey(const Key('edit-profile-button')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('profile-name-field')), '');
    await tester.enterText(
      find.byKey(const Key('profile-email-field')),
      'not-an-email',
    );
    await tester.ensureVisible(find.byKey(const Key('save-profile-button')));
    await tester.tap(find.byKey(const Key('save-profile-button')));
    await tester.pump();

    expect(find.text('Enter your display name.'), findsOneWidget);
    expect(find.text('Enter a valid email address.'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('profile-name-field')),
      'Bahar Demo',
    );
    await tester.enterText(
      find.byKey(const Key('profile-email-field')),
      'bahar@example.com',
    );
    await tester.tap(find.byKey(const Key('save-profile-button')));
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();

    expect(find.text('Bahar Demo'), findsWidgets);
    expect(find.text('bahar@example.com'), findsWidgets);
    expect(find.byKey(const Key('edit-profile-button')), findsOneWidget);
  });

  testWidgets('profile cancel discards draft changes', (tester) async {
    setPhoneViewport(tester);
    await tester.pumpWidget(buildTestApp(const ProfileScreen()));

    await tester.tap(find.byKey(const Key('edit-profile-button')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('profile-name-field')),
      'Unsaved Name',
    );
    await tester.ensureVisible(find.byKey(const Key('cancel-profile-button')));
    await tester.tap(find.byKey(const Key('cancel-profile-button')));
    await tester.pumpAndSettle();

    expect(find.text('Demo User'), findsWidgets);
    expect(find.text('Unsaved Name'), findsNothing);
    expect(find.text('Your changes were not saved.'), findsOneWidget);
  });

  testWidgets('appointments render demo status and booking validation', (
    tester,
  ) async {
    setPhoneViewport(tester);
    await tester.pumpWidget(
      buildTestApp(AppointmentsScreen(today: DateTime(2026, 10, 26))),
    );

    expect(find.text('My Appointments'), findsOneWidget);
    expect(find.text('Food Pantry'), findsOneWidget);
    expect(find.text('Demo • Not confirmed'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const Key('book-appointment-button')),
    );
    await tester.tap(find.byKey(const Key('book-appointment-button')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('book-appointment-sheet')), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('submit-booking-button')));
    await tester.tap(find.byKey(const Key('submit-booking-button')));
    await tester.pump();

    expect(
      find.text('Select a service, date, and demo time to continue.'),
      findsOneWidget,
    );
  });

  testWidgets('removing a demo appointment requires confirmation', (
    tester,
  ) async {
    setPhoneViewport(tester);
    final appointment = Appointment(
      id: 'test-appointment',
      service: AppointmentService.counseling,
      startsAt: DateTime(2026, 10, 28, 13),
      status: AppointmentStatus.demo,
    );
    await tester.pumpWidget(
      buildTestApp(
        AppointmentsScreen(
          today: DateTime(2026, 10, 26),
          initialAppointments: [appointment],
        ),
      ),
    );

    await tester.tap(
      find.byKey(const Key('remove-appointment-test-appointment')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Remove this appointment?'), findsOneWidget);

    await tester.tap(find.text('Keep Appointment'));
    await tester.pumpAndSettle();
    expect(find.text('Counseling'), findsOneWidget);

    await tester.tap(
      find.byKey(const Key('remove-appointment-test-appointment')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    expect(find.text('Counseling'), findsNothing);
    expect(find.byKey(const Key('appointments-empty-state')), findsOneWidget);
  });
}
