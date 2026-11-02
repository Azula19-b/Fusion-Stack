import 'package:flutter/material.dart';

import 'home_screen.dart' show HomeColors;

class VolunteeringScreen extends StatelessWidget {
  const VolunteeringScreen({
    super.key,
    this.onFindOpportunities,
    this.onViewSchedule,
    this.onContact,
  });

  final VoidCallback? onFindOpportunities;
  final VoidCallback? onViewSchedule;
  final VoidCallback? onContact;

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
          'Volunteering',
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
                      title: 'Volunteer Opportunities',
                      subtitle:
                          'Find ways to support First Refuge Ministries and serve the community.',
                    ),

                    const SizedBox(height: 12),

                    const _InfoCard(
                      icon: Icons.volunteer_activism_outlined,
                      title: 'Available Opportunities',
                      description:
                          'Current volunteer opportunities and available roles will appear here.',
                    ),

                    const SizedBox(height: 12),

                    const _InfoCard(
                      icon: Icons.assignment_ind_outlined,
                      title: 'Requirements & Orientation',
                      description:
                          'Volunteer requirements, orientation information, and next steps will appear here.',
                    ),

                    const SizedBox(height: 12),

                    const _InfoCard(
                      icon: Icons.location_on_outlined,
                      title: 'Location & Hours',
                      description:
                          'Volunteer locations, available hours, and arrival information will appear here.',
                    ),

                    const SizedBox(height: 24),

                    const _SectionTitle(
                      title: 'Your Volunteer Schedule',
                      subtitle:
                          'Review upcoming volunteer activities or find a new opportunity.',
                    ),

                    const SizedBox(height: 12),

                    _ScheduleCard(
                      onFindOpportunities: () {
                        if (onFindOpportunities != null) {
                          onFindOpportunities!();
                        } else {
                          _showMessage(
                            context,
                            'Volunteer opportunities will be available here once the volunteer system is connected.',
                          );
                        }
                      },
                      onViewSchedule: () {
                        if (onViewSchedule != null) {
                          onViewSchedule!();
                        } else {
                          _showMessage(
                            context,
                            'Your volunteer schedule will appear here once volunteer data is connected.',
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 24),

                    const _SectionTitle(
                      title: 'Before You Volunteer',
                      subtitle:
                          'Review helpful information before your volunteer activity.',
                    ),

                    const SizedBox(height: 12),

                    const _PreparationCard(),

                    const SizedBox(height: 24),

                    _HelpCard(
                      onContact: () {
                        if (onContact != null) {
                          onContact!();
                        } else {
                          _showMessage(
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
              Icons.volunteer_activism_outlined,
              color: HomeColors.missionBlue,
              size: 30,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Make a difference',
            style: TextStyle(
              color: HomeColors.darkCharcoal,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Explore volunteer opportunities and find ways to support First Refuge Ministries and the community.',
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
                if (onFindOpportunities != null) {
                  onFindOpportunities!();
                } else {
                  _showMessage(
                    context,
                    'Volunteer opportunities will be available here once the volunteer system is connected.',
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
              icon: const Icon(Icons.search_rounded),
              label: const Text(
                'Find Volunteer Opportunities',
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

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({
    required this.onFindOpportunities,
    required this.onViewSchedule,
  });

  final VoidCallback onFindOpportunities;
  final VoidCallback onViewSchedule;

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
                'Volunteer Schedule',
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
                  'No upcoming volunteer activity to display',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: HomeColors.darkCharcoal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Your volunteer schedule will appear here when volunteer data is connected.',
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
                  onPressed: onViewSchedule,
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
                  child: const Text('View Schedule'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: onFindOpportunities,
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
                  child: const Text('Find Opportunities'),
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
            title: 'Volunteer instructions',
            description:
                'Instructions for your volunteer activity will appear here.',
          ),
          Divider(
            height: 28,
            color: HomeColors.border,
          ),
          _PreparationRow(
            icon: Icons.badge_outlined,
            title: 'Requirements',
            description:
                'Any requirements or information needed before volunteering will be listed here.',
          ),
          Divider(
            height: 28,
            color: HomeColors.border,
          ),
          _PreparationRow(
            icon: Icons.notifications_none_rounded,
            title: 'Volunteer reminders',
            description:
                'Reminder information for your scheduled volunteer activity will appear here.',
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
                  'Contact First Refuge Ministries if you need help with volunteering or finding opportunities.',
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