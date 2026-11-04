import 'package:flutter/material.dart';

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

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('This teammate-owned service screen is coming soon.'),
        ),
      );
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
          const _CalendarContent(),
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
      body: IndexedStack(
        index: _selectedIndex,
        children: const [_HomeContent(), _ExploreContent(), _AppointmentsContent(), _CalendarContent(), _ProfileContent()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
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

class _AppointmentsContent extends StatelessWidget {
  const _AppointmentsContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        SizedBox(height: 24),
        Text(
          'Appointments',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF14243A),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Appointment details will appear here.',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _CalendarContent extends StatelessWidget {
  const _CalendarContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        SizedBox(height: 24),
        Text(
          'Monthly Calendar',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF14243A),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Calendar details will appear here.',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 24),
        const CircleAvatar(
          radius: 42,
          backgroundColor: Color(0xFFDEE6FF),
          child: Icon(Icons.person_rounded, size: 44, color: Color(0xFF315FEA)),
        ),
        const SizedBox(height: 16),
        Text(
          'Your profile',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF14243A),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Profile details will appear here.',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
