import 'package:flutter/material.dart';
import 'screens/appointments_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/homepage_services/dental_screen.dart';
import 'screens/homepage_services/counseling_screen.dart';
import 'screens/homepage_services/volunteering_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF315FEA);

    return MaterialApp(
      title: 'Welcome to the Testing Home Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: blue,
          primary: blue,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7FC),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.onSignOut});

  final Future<void> Function(BuildContext context)? onSignOut;


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  HomeLanguage _language = HomeLanguage.english;

  void _goHome() => setState(() => _selectedIndex = 0);

  void _handleServiceSelection(HomeServiceType service) {
    if (service == HomeServiceType.myAppointments) {
      setState(() => _selectedIndex = 2);
      return;
    }
    if (service == HomeServiceType.medicalCare) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Medical care services will be applied soon.'),
          ),
        );
      return;
    }
    if (service == HomeServiceType.dentalCare) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => DentalScreen(
            onViewAppointments: () {
              Navigator.of(context).pop();
              setState(() => _selectedIndex = 2);
            },
          ),
        ),
      );
      return;
    }
    if (service == HomeServiceType.counseling) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CounselingScreen(
            onViewAppointments: () {
              Navigator.of(context).pop();
              setState(() => _selectedIndex = 2);
            },
          ),
        ),
      );
      return;
    }
    if (service == HomeServiceType.volunteerOpportunities) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => VolunteeringScreen(
            onViewSchedule: () {
              Navigator.of(context).pop();
              setState(() => _selectedIndex = 2);
            },
          ),
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(
            initialLanguage: _language,
            onLanguageChanged: (language) {
              setState(() => _language = language);
            },
            onServiceSelected: _handleServiceSelection,
          ),
          const _ExploreContent(),
          AppointmentsScreen(onBack: _goHome),
          const CalendarScreen(),
          ProfileScreen(
            onBack: _goHome,
            onSignOut: widget.onSignOut == null
                ? null
                : () => widget.onSignOut!(context),
            initialLanguage: _language,
            onLanguageChanged: (language) {
              setState(() => _language = language);
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        height: 72,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
          (states) => TextStyle(
            fontSize: states.contains(WidgetState.selected) ? 12 : 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_available_outlined),
            selectedIcon: Icon(Icons.event_available_rounded),
            label: 'Appointments',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _ExploreContent extends StatelessWidget {
  const _ExploreContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      children: const [
        SafeArea(
          bottom: false,
          child: Text(
            'Explore',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: HomeColors.darkCharcoal,
            ),
          ),
        ),
        SizedBox(height: 18),
        _ExploreCard(
          title: 'Who we are?',
          subtitle: 'Learn about FRM and its work in the community.',
          icon: Icons.info_outline_rounded,
        ),
        SizedBox(height: 12),
        _ExploreCard(
          title: 'Services and support',
          subtitle: 'Explore counseling, health, food pantry, and volunteering services.',
          icon: Icons.volunteer_activism_outlined,
        ),
        SizedBox(height: 12),
        _ExploreCard(
          title: 'Contact information',
          subtitle: 'Find the email, phone number, and address.',
          icon: Icons.contact_mail_outlined,
        ),
      ],
    );
  }
}

class _ExploreCard extends StatelessWidget {
  const _ExploreCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEEF2FF),
          foregroundColor: const Color(0xFF315FEA),
          child: Icon(icon),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle),
        ),
      ),
    );
  }
}