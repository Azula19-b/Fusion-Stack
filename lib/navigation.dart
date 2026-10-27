import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          HomeScreen(),
          _ExploreContent(),
          _AppointmentsContent(),
          _CalendarContent(),
          _ProfileContent(),
        ],
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
      padding: const EdgeInsets.all(20),
      children: const [
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
        Text('Calendar details will appear here.', textAlign: TextAlign.center),
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
