import '../models/home_service_type.dart';

enum HomeLanguage { english, spanish }

class ServiceLocalization {
  const ServiceLocalization({required this.title, required this.subtitle});

  final String title;
  final String subtitle;
}

class AppLocalizations {
  const AppLocalizations({
    required this.logoSemantics,
    required this.languageLabel,
    required this.eyebrow,
    required this.heading,
    required this.welcome,
    required this.servicesHeading,
    required this.serviceSingular,
    required this.servicePlural,
    required this.searchHint,
    required this.clearSearch,
    required this.emptyTitle,
    required this.emptyBody,
    required this.comingSoon,
    required this.openService,
    required this.supportNote,
    required this.services,
  });

  final String logoSemantics;
  final String languageLabel;
  final String eyebrow;
  final String heading;
  final String welcome;
  final String servicesHeading;
  final String serviceSingular;
  final String servicePlural;
  final String searchHint;
  final String clearSearch;
  final String emptyTitle;
  final String emptyBody;
  final String comingSoon;
  final String openService;
  final String supportNote;
  final Map<HomeServiceType, ServiceLocalization> services;

  String resultCount(int count) =>
      '$count ${count == 1 ? serviceSingular : servicePlural}';

  static AppLocalizations of(HomeLanguage language) =>
      _localizations[language]!;
}

const _localizations = <HomeLanguage, AppLocalizations>{
  HomeLanguage.english: AppLocalizations(
    logoSemantics: 'First Refuge Ministries',
    languageLabel: 'Choose language',
    eyebrow: 'RELIEF  •  AID  •  CARE',
    heading: 'How can we help you today?',
    welcome: 'Compassionate care and practical support for our Denton County neighbors—right when you need it.',
    servicesHeading: 'Find support',
    serviceSingular: 'service',
    servicePlural: 'services',
    searchHint: 'Search services',
    clearSearch: 'Clear search',
    emptyTitle: 'No services found',
    emptyBody: 'Try “medical,” “food,” or “appointments.”',
    comingSoon: 'This service screen will be connected soon.',
    openService: 'Open service',
    supportNote: 'You are welcome here. Explore a service to find the care and support you need.',
    services: {
      HomeServiceType.medicalCare: ServiceLocalization(
        title: 'Medical Care',
        subtitle: 'Compassionate health services for our community.',
      ),
      HomeServiceType.dentalCare: ServiceLocalization(
        title: 'Dental Care',
        subtitle: 'Essential oral care to help you smile with confidence.',
      ),
      HomeServiceType.counseling: ServiceLocalization(
        title: 'Counseling',
        subtitle: 'A caring space for emotional and spiritual support.',
      ),
      HomeServiceType.foodPantry: ServiceLocalization(
        title: 'Food Pantry',
        subtitle: 'Fresh groceries and pantry staples for your household.',
      ),
      HomeServiceType.volunteerOpportunities: ServiceLocalization(
        title: 'Volunteer Opportunities',
        subtitle: 'Share your time and talents with neighbors in need.',
      ),
      HomeServiceType.myAppointments: ServiceLocalization(
        title: 'My Appointments',
        subtitle: 'View and manage your upcoming visits in one place.',
      ),
    },
  ),
  HomeLanguage.spanish: AppLocalizations(
    logoSemantics: 'First Refuge Ministries',
    languageLabel: 'Elegir idioma',
    eyebrow: 'ALIVIO  •  AYUDA  •  CUIDADO',
    heading: '¿Cómo podemos ayudarle hoy?',
    welcome: 'Atención compasiva y apoyo práctico para nuestros vecinos del condado de Denton, justo cuando lo necesitan.',
    servicesHeading: 'Encuentre apoyo',
    serviceSingular: 'servicio',
    servicePlural: 'servicios',
    searchHint: 'Buscar servicios',
    clearSearch: 'Borrar búsqueda',
    emptyTitle: 'No encontramos servicios',
    emptyBody: 'Pruebe “médico”, “alimentos” o “citas”.',
    comingSoon: 'Esta pantalla de servicio se conectará pronto.',
    openService: 'Abrir servicio',
    supportNote: 'Usted es bienvenido aquí. Explore un servicio para encontrar la atención y el apoyo que necesita.',
    services: {
      HomeServiceType.medicalCare: ServiceLocalization(
        title: 'Atención médica',
        subtitle: 'Servicios de salud compasivos para nuestra comunidad.',
      ),
      HomeServiceType.dentalCare: ServiceLocalization(
        title: 'Atención dental',
        subtitle: 'Cuidado bucal esencial para sonreír con confianza.',
      ),
      HomeServiceType.counseling: ServiceLocalization(
        title: 'Consejería',
        subtitle: 'Un espacio de apoyo emocional y espiritual.',
      ),
      HomeServiceType.foodPantry: ServiceLocalization(
        title: 'Despensa de alimentos',
        subtitle: 'Alimentos frescos y básicos para su hogar.',
      ),
      HomeServiceType.volunteerOpportunities: ServiceLocalization(
        title: 'Oportunidades de voluntariado',
        subtitle: 'Comparta su tiempo y talento con quienes lo necesitan.',
      ),
      HomeServiceType.myAppointments: ServiceLocalization(
        title: 'Mis citas',
        subtitle: 'Vea y administre sus próximas visitas en un solo lugar.',
      ),
    },
  ),
};
