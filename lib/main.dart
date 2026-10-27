import 'package:amplify_auth_cognito/amplify_auth_cognito.dart'
    show AmplifyAuthCognito;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

import 'amplify_outputs.dart';
import 'screens/welcome_screen.dart' as welcome;

Future<void> _configureAmplify() async {
  try {
    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.configure(amplifyConfig);
    safePrint('Amplify configured successfully');
  } on AmplifyAlreadyConfiguredException {
    safePrint('Amplify was already configured');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF14243A);
    const blue = Color(0xFF315FEA);

    return MaterialApp(
      title: 'Welcome',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: blue,
          primary: blue,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7FC),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF7F9FC),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 17,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: blue, width: 1.5),
          ),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: navy,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.7,
          ),
          bodyMedium: TextStyle(color: Color(0xFF68768A)),
        ),
      ),
      home: const welcome.AuthPage(),
    );
  }
}
