import 'package:flutter/material.dart';

import '../home_screen.dart' show HomeColors;

class DentalScreen extends StatelessWidget {
  const DentalScreen({
    super.key,
    this.onScheduleAppointment,
    this.onViewAppointments,
    this.onContact,
  });

  final VoidCallback? onScheduleAppointment;
  final VoidCallback? onViewAppointments;
  final VoidCallback? onContact;

  void _showNotConnectedMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Dental Care',
          style: TextStyle(
            color: HomeColors.darkCharcoal,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildWelcomeCard(context),
                    const SizedBox(height: 24),

                    const _SectionTitle(
                      title: 'Dental Services',
                      subtitle:
                          'Find the information you need before scheduling a dental visit.',
                    ),
                    const SizedBox(height: 12),

                    const _InfoCard(
                      icon: Icons.medical_services_outlined,
                      title: 'Available Dental Services',
                      description:
                          'Dental services provided by First Refuge Ministries will appear here.',
                    ),
                    const SizedBox(height: 12),

                    const _InfoCard(
                      icon: Icons.assignment_outlined,
                      title: 'Eligibility & Required Information',
                      description:
                          'Eligibility requirements and any documents needed for your visit will appear here.',
                    ),
                    const SizedBox(height: 12),

                    const _InfoCard(
                      icon: Icons.location_on_outlined,
                      title: 'Location & Hours',
                      description:
                          'Dental clinic location, operating hours, and arrival information will appear here.',
                    ),
                    const SizedBox(height: 24),

                    const _SectionTitle(
                      title: 'Your Appointment',
                      subtitle:
                          'Schedule a dental visit or review an upcoming appointment.',
                    ),
                    const SizedBox(height: 12),

                    _AppointmentCard(
                      onSchedule: () {
                        if (onScheduleAppointment != null) {
                          onScheduleAppointment!();
                        } else {
                          _showNotConnectedMessage(
                            context,
                            'Dental scheduling will be available here once the scheduling system is connected.',
                          );
                        }
                      },
                      onViewAppointments: () {
                        if (onViewAppointments != null) {
                          onViewAppointments!();
                        } else {
                          _showNotConnectedMessage(
                            context,
                            'Your dental appointments will appear here once appointment data is connected.',
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 24),

                    const _SectionTitle(
                      title: 'Before Your Visit',
                      subtitle:
                          'Review important information before your dental appointment.',
                    ),
                    const SizedBox(height: 12),

                    const _PreparationCard(),

                    const SizedBox(height: 24),

                    _HelpCard(
                      onContact: () {
                        if (onContact != null) {
                          onContact!();
                        } else {
                          _showNotConnectedMessage(
                            context,
                            'First Refuge Ministries contact information will be available here.',
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: HomeColors.lightBlue,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: HomeColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.health_and_safety_outlined,
              color: HomeColors.missionBlue,
              size: 30,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Dental care made easier',
            style: TextStyle(
              color: HomeColors.darkCharcoal,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Access dental services, appointment information, and visit details from one place.',
            style: TextStyle(
              color: HomeColors.mutedText,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                if (onScheduleAppointment != null) {
                  onScheduleAppointment!();
                } else {
                  _showNotConnectedMessage(
                    context,
                    'Dental scheduling will be available here once the scheduling system is connected.',
                  );
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: HomeColors.missionBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.calendar_month_outlined),
              label: const Text(
                'Schedule Dental Appointment',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: HomeColors.darkCharcoal,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: HomeColors.mutedText,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: HomeColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: HomeColors.lightBlue,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: HomeColors.deepBlue,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: HomeColors.darkCharcoal,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    color: HomeColors.mutedText,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({
    required this.onSchedule,
    required this.onViewAppointments,
  });

  final VoidCallback onSchedule;
  final VoidCallback onViewAppointments;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: HomeColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.event_available_outlined,
                color: HomeColors.missionBlue,
              ),
              SizedBox(width: 10),
              Text(
                'Dental Appointment',
                style: TextStyle(
                  color: HomeColors.darkCharcoal,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F9FC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: HomeColors.mutedText,
                  size: 30,
                ),
                SizedBox(height: 10),
                Text(
                  'No upcoming dental appointment to display',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: HomeColors.darkCharcoal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Your appointment details will appear here when scheduling data is connected.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: HomeColors.mutedText,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onViewAppointments,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: HomeColors.deepBlue,
                    side: const BorderSide(
                      color: HomeColors.border,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('View Appointments'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: onSchedule,
                  style: FilledButton.styleFrom(
                    backgroundColor: HomeColors.missionBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Schedule'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreparationCard extends StatelessWidget {
  const _PreparationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: HomeColors.border,
        ),
      ),
      child: const Column(
        children: [
          _PreparationRow(
            icon: Icons.check_circle_outline,
            title: 'Appointment instructions',
            description:
                'Preparation instructions from First Refuge Ministries will appear here.',
          ),
          Divider(
            height: 28,
            color: HomeColors.border,
          ),
          _PreparationRow(
            icon: Icons.description_outlined,
            title: 'Required documents',
            description:
                'Any documents needed for your dental visit will be listed here.',
          ),
          Divider(
            height: 28,
            color: HomeColors.border,
          ),
          _PreparationRow(
            icon: Icons.notifications_none_rounded,
            title: 'Appointment reminders',
            description:
                'Reminder information for your scheduled dental visit will appear here.',
          ),
        ],
      ),
    );
  }
}

class _PreparationRow extends StatelessWidget {
  const _PreparationRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: HomeColors.missionBlue,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: HomeColors.darkCharcoal,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: HomeColors.mutedText,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HelpCard extends StatelessWidget {
  const _HelpCard({
    required this.onContact,
  });

  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: HomeColors.darkCharcoal,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need help?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Contact First Refuge Ministries if you need help with dental services or scheduling.',
                  style: TextStyle(
                    color: Color(0xFFDDE5EA),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          IconButton.filled(
            onPressed: onContact,
            style: IconButton.styleFrom(
              backgroundColor: HomeColors.missionBlue,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.arrow_forward_rounded),
          ),
        ],
      ),
    );
  }
}