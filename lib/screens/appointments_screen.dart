import 'package:flutter/material.dart';

import '../models/appointment.dart';
import 'home_screen.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({
    super.key,
    this.onBack,
    this.initialAppointments,
    this.today,
  });

  final VoidCallback? onBack;
  final List<Appointment>? initialAppointments;
  final DateTime? today;

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  late final DateTime _today;
  late final List<Appointment> _appointments;

  @override
  void initState() {
    super.initState();
    final now = widget.today ?? DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _appointments = widget.initialAppointments != null
        ? List<Appointment>.of(widget.initialAppointments!)
        : [
            Appointment(
              id: 'demo-food-pantry',
              service: AppointmentService.foodPantry,
              startsAt: _today.add(
                const Duration(days: 2, hours: 10, minutes: 30),
              ),
              status: AppointmentStatus.demo,
              details: 'Front desk check-in • Demonstration data',
            ),
          ];
  }

  List<Appointment> get _todayAppointments {
    return _appointments
        .where((appointment) => _isSameDay(appointment.startsAt, _today))
        .toList()
      ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
  }

  List<Appointment> get _upcomingAppointments {
    return _appointments
        .where(
          (appointment) =>
              appointment.startsAt.isAfter(_today) &&
              !_isSameDay(appointment.startsAt, _today),
        )
        .toList()
      ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  Future<void> _openBooking() async {
    final appointment = await showModalBottomSheet<Appointment>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: HomeColors.white,
      builder: (context) => _BookAppointmentSheet(
        today: _today,
        existingAppointments: _appointments,
      ),
    );

    if (appointment == null || !mounted) return;
    setState(() => _appointments.add(appointment));

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.check_circle_outline_rounded,
          color: HomeColors.deepBlue,
          size: 42,
        ),
        title: const Text('Demo appointment saved'),
        content: const Text(
          'This appointment was added only to the local demonstration. It is not confirmed with First Refuge Ministries.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Future<void> _removeAppointment(Appointment appointment) async {
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove this appointment?'),
        content: Text(
          'Remove the local demo ${appointment.service.label} appointment from this list?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep Appointment'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (shouldRemove != true || !mounted) return;
    setState(
      () => _appointments.removeWhere((item) => item.id == appointment.id),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Demo appointment removed locally.')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final todayAppointments = _todayAppointments;
    final upcomingAppointments = _upcomingAppointments;

    return Scaffold(
      backgroundColor: HomeColors.white,
      body: SafeArea(
        bottom: false,
        child: ListView(
          key: const Key('appointments-screen'),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            _AppointmentsHeader(onBack: widget.onBack),
            const SizedBox(height: 20),
            const _DemoAvailabilityNotice(),
            const SizedBox(height: 26),
            _SectionHeading(
              title: "Today's appointments",
              count: todayAppointments.length,
            ),
            const SizedBox(height: 12),
            if (todayAppointments.isEmpty)
              const _SmallEmptyState(
                key: Key('today-appointments-empty'),
                message: 'No demo appointments are listed for today.',
              )
            else
              ...todayAppointments.map(
                (appointment) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _AppointmentCard(
                    appointment: appointment,
                    onRemove: () => _removeAppointment(appointment),
                  ),
                ),
              ),
            const SizedBox(height: 28),
            _SectionHeading(
              title: 'Upcoming appointments',
              count: upcomingAppointments.length,
            ),
            const SizedBox(height: 12),
            if (upcomingAppointments.isEmpty)
              const _AppointmentsEmptyState()
            else
              ...upcomingAppointments.map(
                (appointment) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _AppointmentCard(
                    appointment: appointment,
                    onRemove: () => _removeAppointment(appointment),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            SizedBox(
              height: 54,
              child: FilledButton.icon(
                key: const Key('book-appointment-button'),
                onPressed: _openBooking,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Book Appointment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentsHeader extends StatelessWidget {
  const _AppointmentsHeader({this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (onBack != null) ...[
          IconButton.filledTonal(
            key: const Key('appointments-back-button'),
            tooltip: 'Back to Home',
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Appointments',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: HomeColors.darkCharcoal,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'View upcoming visits or create a demo booking.',
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: HomeColors.mutedText),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DemoAvailabilityNotice extends StatelessWidget {
  const _DemoAvailabilityNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0D9A7)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.science_outlined, color: Color(0xFF8A5B00)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Demo mode — appointments and time options are not connected to live availability or a scheduling system.',
              style: TextStyle(color: HomeColors.darkCharcoal, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: HomeColors.darkCharcoal,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Container(
          constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: HomeColors.lightBlue,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              color: HomeColors.deepBlue,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({required this.appointment, required this.onRemove});

  final Appointment appointment;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('appointment-card-${appointment.id}'),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: HomeColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: HomeColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F126785),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: HomeColors.lightBlue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  _serviceIcon(appointment.service),
                  color: HomeColors.deepBlue,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.service.label,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: HomeColors.darkCharcoal,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [_StatusBadge(status: appointment.status)],
                    ),
                  ],
                ),
              ),
              IconButton(
                key: Key('remove-appointment-${appointment.id}'),
                tooltip: 'Remove appointment',
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _AppointmentDetail(
            icon: Icons.calendar_today_outlined,
            text: _formatDate(appointment.startsAt),
          ),
          const SizedBox(height: 10),
          _AppointmentDetail(
            icon: Icons.schedule_rounded,
            text: _formatTime(appointment.startsAt),
          ),
          if ((appointment.details ?? '').isNotEmpty) ...[
            const SizedBox(height: 10),
            _AppointmentDetail(
              icon: Icons.info_outline_rounded,
              text: appointment.details!,
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final AppointmentStatus status;

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      AppointmentStatus.demo => 'Demo • Not confirmed',
      AppointmentStatus.scheduled => 'Scheduled',
      AppointmentStatus.completed => 'Completed',
      AppointmentStatus.cancelled => 'Cancelled',
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1CC),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF755000),
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _AppointmentDetail extends StatelessWidget {
  const _AppointmentDetail({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 19, color: HomeColors.deepBlue),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: HomeColors.darkCharcoal, height: 1.35),
          ),
        ),
      ],
    );
  }
}

class _SmallEmptyState extends StatelessWidget {
  const _SmallEmptyState({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EBEF)),
      ),
      child: Row(
        children: [
          const Icon(Icons.event_busy_outlined, color: HomeColors.mutedText),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}

class _AppointmentsEmptyState extends StatelessWidget {
  const _AppointmentsEmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('appointments-empty-state'),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
      decoration: BoxDecoration(
        color: HomeColors.lightBlue.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: HomeColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.event_available_outlined,
            color: HomeColors.deepBlue,
            size: 42,
          ),
          const SizedBox(height: 12),
          Text(
            'No upcoming appointments',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: HomeColors.darkCharcoal,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Use the button below to try the demonstration booking flow.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _BookAppointmentSheet extends StatefulWidget {
  const _BookAppointmentSheet({
    required this.today,
    required this.existingAppointments,
  });

  final DateTime today;
  final List<Appointment> existingAppointments;

  @override
  State<_BookAppointmentSheet> createState() => _BookAppointmentSheetState();
}

class _BookAppointmentSheetState extends State<_BookAppointmentSheet> {
  AppointmentService? _service;
  DateTime? _date;
  TimeOfDay? _time;
  String? _formError;
  bool _isSubmitting = false;

  static const _demoTimes = <TimeOfDay>[
    TimeOfDay(hour: 9, minute: 0),
    TimeOfDay(hour: 10, minute: 30),
    TimeOfDay(hour: 13, minute: 0),
    TimeOfDay(hour: 14, minute: 30),
  ];

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _date ?? widget.today.add(const Duration(days: 1)),
      firstDate: widget.today,
      lastDate: widget.today.add(const Duration(days: 120)),
      helpText: 'Select a demo appointment date',
    );
    if (selected != null && mounted) {
      setState(() {
        _date = selected;
        _formError = null;
      });
    }
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    if (_service == null || _date == null || _time == null) {
      setState(() {
        _formError = 'Select a service, date, and demo time to continue.';
      });
      return;
    }

    final startsAt = DateTime(
      _date!.year,
      _date!.month,
      _date!.day,
      _time!.hour,
      _time!.minute,
    );
    final duplicate = widget.existingAppointments.any(
      (appointment) =>
          appointment.service == _service && appointment.startsAt == startsAt,
    );
    if (duplicate) {
      setState(() {
        _formError = 'That demo appointment is already in your list. Choose another time.';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _formError = null;
    });
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    Navigator.of(context).pop(
      Appointment(
        id: 'demo-${startsAt.microsecondsSinceEpoch}-${_service!.name}',
        service: _service!,
        startsAt: startsAt,
        status: AppointmentStatus.demo,
        details: 'Local demonstration booking • Not submitted',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectionComplete =
        _service != null && _date != null && _time != null;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        key: const Key('book-appointment-sheet'),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCAD4D9),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Book Appointment',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: HomeColors.darkCharcoal,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Close booking form',
                  onPressed: _isSubmitting
                      ? null
                      : () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'This flow uses sample times for UI review only. No real availability is shown.',
              style: TextStyle(color: HomeColors.mutedText, height: 1.4),
            ),
            const SizedBox(height: 24),
            const _StepLabel(number: 1, label: 'Select a service'),
            const SizedBox(height: 10),
            DropdownButtonFormField<AppointmentService>(
              key: const Key('appointment-service-field'),
              initialValue: _service,
              decoration: const InputDecoration(
                hintText: 'Choose a service',
                prefixIcon: Icon(Icons.volunteer_activism_outlined),
              ),
              items: AppointmentService.values
                  .map(
                    (service) => DropdownMenuItem(
                      value: service,
                      child: Text(service.label),
                    ),
                  )
                  .toList(),
              onChanged: _isSubmitting
                  ? null
                  : (value) => setState(() {
                      _service = value;
                      _formError = null;
                    }),
            ),
            const SizedBox(height: 22),
            const _StepLabel(number: 2, label: 'Choose a date'),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              key: const Key('appointment-date-button'),
              onPressed: _isSubmitting ? null : _selectDate,
              icon: const Icon(Icons.calendar_today_outlined),
              label: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _date == null ? 'Select a date' : _formatDate(_date!),
                ),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
                alignment: Alignment.centerLeft,
              ),
            ),
            const SizedBox(height: 22),
            const _StepLabel(number: 3, label: 'Choose a demo time'),
            const SizedBox(height: 4),
            const Text(
              'Sample options — not live availability',
              style: TextStyle(color: HomeColors.mutedText, fontSize: 12),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 9,
              runSpacing: 9,
              children: _demoTimes
                  .map(
                    (time) => ChoiceChip(
                      key: Key('appointment-time-${time.hour}-${time.minute}'),
                      label: Text(time.format(context)),
                      selected: _time == time,
                      onSelected: _isSubmitting
                          ? null
                          : (selected) => setState(() {
                              _time = selected ? time : null;
                              _formError = null;
                            }),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
            const _StepLabel(number: 4, label: 'Review'),
            const SizedBox(height: 10),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: selectionComplete
                  ? _BookingSummary(
                      service: _service!,
                      date: _date!,
                      time: _time!,
                    )
                  : const _ReviewPlaceholder(),
            ),
            if (_formError != null) ...[
              const SizedBox(height: 14),
              Semantics(
                liveRegion: true,
                child: Text(
                  _formError!,
                  key: const Key('booking-form-error'),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 22),
            SizedBox(
              height: 54,
              child: FilledButton.icon(
                key: const Key('submit-booking-button'),
                onPressed: _isSubmitting ? null : _submit,
                icon: _isSubmitting
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_rounded),
                label: Text(
                  _isSubmitting ? 'Saving Demo…' : 'Save Demo Appointment',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepLabel extends StatelessWidget {
  const _StepLabel({required this.number, required this.label});

  final int number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 13,
          backgroundColor: HomeColors.deepBlue,
          foregroundColor: HomeColors.white,
          child: Text(
            '$number',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(width: 9),
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: HomeColors.darkCharcoal,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _BookingSummary extends StatelessWidget {
  const _BookingSummary({
    required this.service,
    required this.date,
    required this.time,
  });

  final AppointmentService service;
  final DateTime date;
  final TimeOfDay time;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('booking-summary'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HomeColors.lightBlue,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HomeColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            service.label,
            style: const TextStyle(
              color: HomeColors.darkCharcoal,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Text('${_formatDate(date)} at ${time.format(context)}'),
          const SizedBox(height: 8),
          const Text(
            'Demo only • This will not contact First Refuge Ministries.',
            style: TextStyle(
              color: Color(0xFF755000),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewPlaceholder extends StatelessWidget {
  const _ReviewPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('booking-review-placeholder'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EBEF)),
      ),
      child: const Text(
        'Your booking summary will appear after all three selections are made.',
      ),
    );
  }
}

IconData _serviceIcon(AppointmentService service) => switch (service) {
  AppointmentService.foodPantry => Icons.shopping_basket_outlined,
  AppointmentService.healthcare => Icons.medical_services_outlined,
  AppointmentService.dental => Icons.health_and_safety_outlined,
  AppointmentService.counseling => Icons.favorite_outline_rounded,
};

String _formatDate(DateTime date) {
  const weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
}

String _formatTime(DateTime date) {
  final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final minute = date.minute.toString().padLeft(2, '0');
  final period = date.hour < 12 ? 'AM' : 'PM';
  return '$hour:$minute $period';
}
