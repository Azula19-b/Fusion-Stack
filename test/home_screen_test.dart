import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frm_app/l10n/app_localizations.dart';
import 'package:frm_app/screens/home_screen.dart';

void main() {
  test('app localizations are available by language across the app', () {
    final english = AppLocalizations.of(HomeLanguage.english);
    final spanish = AppLocalizations.of(HomeLanguage.spanish);

    expect(english.heading, 'How can we help you today?');
    expect(
      spanish.services[HomeServiceType.medicalCare]?.title,
      'Atención médica',
    );
    expect(spanish.resultCount(2), '2 servicios');
  });

  Widget buildHome({ValueChanged<HomeServiceType>? onServiceSelected}) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: HomeScreen(onServiceSelected: onServiceSelected),
    );
  }

  void setViewport(WidgetTester tester, Size size) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('shows all six Home Screen service cards', (tester) async {
    setViewport(tester, const Size(800, 1200));
    await tester.pumpWidget(buildHome());

    expect(find.text('Medical Care'), findsOneWidget);
    expect(find.text('Dental Care'), findsOneWidget);
    expect(find.text('Counseling'), findsOneWidget);
    expect(find.text('Food Pantry'), findsOneWidget);
    expect(find.text('Volunteer Opportunities'), findsOneWidget);
    expect(find.text('My Appointments'), findsOneWidget);
    expect(find.byKey(const Key('service-result-count')), findsOneWidget);
    expect(find.text('6 services'), findsOneWidget);
  });

  testWidgets('search filters by keywords and can be cleared', (tester) async {
    setViewport(tester, const Size(800, 1200));
    await tester.pumpWidget(buildHome());

    await tester.enterText(
      find.byKey(const Key('service-search-field')),
      'teeth',
    );
    await tester.pumpAndSettle();

    expect(find.text('Dental Care'), findsOneWidget);
    expect(find.text('Medical Care'), findsNothing);
    expect(find.text('1 service'), findsOneWidget);

    await tester.tap(find.byKey(const Key('service-search-clear')));
    await tester.pumpAndSettle();

    expect(find.text('Medical Care'), findsOneWidget);
    expect(find.text('6 services'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('service-search-field')),
      'not a real service',
    );
    await tester.pumpAndSettle();
    expect(find.text('No services found'), findsOneWidget);
  });

  testWidgets('language selector updates visible Home Screen content', (
    tester,
  ) async {
    setViewport(tester, const Size(800, 1200));
    await tester.pumpWidget(buildHome());

    expect(find.byKey(const Key('language-selector')), findsOneWidget);
    expect(
      (tester
                  .widget<Image>(
                    find.byKey(const Key('language-selected-flag')),
                  )
                  .image
              as AssetImage)
          .assetName,
      'assets/usFlag.png',
    );
    final selectedFlag = tester.widget<Image>(
      find.byKey(const Key('language-selected-flag')),
    );
    expect(selectedFlag.width, selectedFlag.height);
    expect(selectedFlag.fit, BoxFit.contain);
    expect(
      find.ancestor(
        of: find.byKey(const Key('language-selected-flag')),
        matching: find.byType(ClipOval),
      ),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('language-selector')));
    await tester.pumpAndSettle();
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Español'), findsOneWidget);
    expect(find.byKey(const Key('language-option-flag-en')), findsOneWidget);
    expect(find.byKey(const Key('language-option-flag-es')), findsOneWidget);
    expect(
      find.ancestor(
        of: find.byKey(const Key('language-option-flag-en')),
        matching: find.byType(ClipOval),
      ),
      findsOneWidget,
    );
    expect(
      find.ancestor(
        of: find.byKey(const Key('language-option-flag-es')),
        matching: find.byType(ClipOval),
      ),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('language-es')));
    await tester.pumpAndSettle();

    expect(find.text('¿Cómo podemos ayudarle hoy?'), findsOneWidget);
    expect(find.text('Atención médica'), findsOneWidget);
    expect(find.text('Despensa de alimentos'), findsOneWidget);
    expect(find.text('6 servicios'), findsOneWidget);
    expect(
      (tester
                  .widget<Image>(
                    find.byKey(const Key('language-selected-flag')),
                  )
                  .image
              as AssetImage)
          .assetName,
      'assets/mexFlag.png',
    );

    await tester.tap(find.byKey(const Key('language-selector')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('language-en')));
    await tester.pumpAndSettle();
    expect(find.text('How can we help you today?'), findsOneWidget);
  });

  testWidgets('service card reports its selection through the callback', (
    tester,
  ) async {
    setViewport(tester, const Size(800, 1200));
    HomeServiceType? selectedService;
    await tester.pumpWidget(
      buildHome(onServiceSelected: (service) => selectedService = service),
    );

    final medicalCard = find.byKey(const Key('service-card-medicalCare'));
    await tester.ensureVisible(medicalCard);
    await tester.tap(medicalCard);
    await tester.pump();

    expect(selectedService, HomeServiceType.medicalCare);
    expect(
      find.text('This service screen will be connected soon.'),
      findsNothing,
    );
  });

  testWidgets('uses two columns when mobile width allows', (tester) async {
    setViewport(tester, const Size(430, 1200));
    await tester.pumpWidget(buildHome());

    final medical = tester.getTopLeft(
      find.byKey(const Key('service-card-medicalCare')),
    );
    final dental = tester.getTopLeft(
      find.byKey(const Key('service-card-dentalCare')),
    );

    expect(medical.dy, dental.dy);
    expect(dental.dx, greaterThan(medical.dx));
  });

  testWidgets('uses one column on a narrow screen without overflow', (
    tester,
  ) async {
    setViewport(tester, const Size(320, 1200));
    await tester.pumpWidget(buildHome());

    final medical = tester.getTopLeft(
      find.byKey(const Key('service-card-medicalCare')),
    );
    final dental = tester.getTopLeft(
      find.byKey(const Key('service-card-dentalCare')),
    );

    expect(dental.dy, greaterThan(medical.dy));
    expect(tester.takeException(), isNull);
  });

  testWidgets('supports increased text size without layout overflow', (
    tester,
  ) async {
    setViewport(tester, const Size(430, 1200));
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(buildHome());

    final medical = tester.getTopLeft(
      find.byKey(const Key('service-card-medicalCare')),
    );
    final dental = tester.getTopLeft(
      find.byKey(const Key('service-card-dentalCare')),
    );

    expect(dental.dy, greaterThan(medical.dy));
    expect(tester.takeException(), isNull);
  });
}
