enum AppointmentService { foodPantry, healthcare, dental, counseling }

extension AppointmentServiceLabel on AppointmentService {
  String get label => switch (this) {
    AppointmentService.foodPantry => 'Food Pantry',
    AppointmentService.healthcare => 'Healthcare',
    AppointmentService.dental => 'Dental',
    AppointmentService.counseling => 'Counseling',
  };
}

enum AppointmentStatus { demo, scheduled, completed, cancelled }

class Appointment {
  const Appointment({
    required this.id,
    required this.service,
    required this.startsAt,
    required this.status,
    this.details,
  });

  final String id;
  final AppointmentService service;
  final DateTime startsAt;
  final AppointmentStatus status;
  final String? details;
}
