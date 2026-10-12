import 'package:flutter/material.dart';

/// First Refuge Ministries' primary brand colors.
abstract final class HomeColors {
  static const missionBlue = Color(0xFF2596BE);
  static const darkCharcoal = Color(0xFF24282D);
  static const lightBlue = Color(0xFFEAF6FB);
  static const white = Color(0xFFFFFFFF);

  // A darker companion to Mission Blue provides accessible contrast for text.
  static const deepBlue = Color(0xFF126785);
  static const mutedText = Color(0xFF52616B);
  static const border = Color(0xFFD5E9F1);
}

enum HomeLanguage { english, spanish }

enum HomeServiceType {
  medicalCare,
  dentalCare,
  counseling,
  foodPantry,
  volunteerOpportunities,
  myAppointments,
}

/// A reusable Home Screen that owns only local presentation state.
///
/// [onServiceSelected] lets the parent application connect each card to the
/// appropriate teammate-owned screen later. When it is omitted, the screen
/// shows a preview-only SnackBar and does not create placeholder routes.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.onServiceSelected,
    this.initialLanguage = HomeLanguage.english,
    this.onLanguageChanged,
  });

  final ValueChanged<HomeServiceType>? onServiceSelected;
  final HomeLanguage initialLanguage;
  final ValueChanged<HomeLanguage>? onLanguageChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  late HomeLanguage _language;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _language = widget.initialLanguage;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  _HomeCopy get _copy => _copies[_language]!;

  List<_ServiceDefinition> get _filteredServices {
    final query = _normalize(_query);
    if (query.isEmpty) return _services;

    return _services.where((service) {
      final localized = service.copy[_language]!;
      final searchableText = <String>[
        localized.title,
        localized.subtitle,
        ...service.keywords,
      ].map(_normalize).join(' ');
      return searchableText.contains(query);
    }).toList();
  }

  String _normalize(String value) => value.toLowerCase().trim();

  void _setLanguage(HomeLanguage language) {
    if (language == _language) return;
    setState(() => _language = language);
    widget.onLanguageChanged?.call(language);
  }

  void _selectService(HomeServiceType service) {
    final callback = widget.onServiceSelected;
    if (callback != null) {
      callback(service);
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(_copy.comingSoon),
          behavior: SnackBarBehavior.floating,
          showCloseIcon: true,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.white,
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverToBoxAdapter(
            child: _HomeHeader(
              copy: _copy,
              language: _language,
              onLanguageChanged: _setLanguage,
            ),
          ),
          SliverSafeArea(
            top: false,
            sliver: SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _WelcomeSection(copy: _copy),
                        const SizedBox(height: 30),
                        _ServicesHeading(
                          copy: _copy,
                          resultCount: _filteredServices.length,
                        ),
                        const SizedBox(height: 16),
                        _SearchField(
                          controller: _searchController,
                          copy: _copy,
                          onChanged: (value) => setState(() => _query = value),
                          onClear: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        ),
                        const SizedBox(height: 20),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeIn,
                          child: _filteredServices.isEmpty
                              ? _EmptyState(
                                  key: const ValueKey('empty-state'),
                                  copy: _copy,
                                )
                              : _ServiceGrid(
                                  key: ValueKey(
                                    '${_language.name}-${_query.trim()}',
                                  ),
                                  services: _filteredServices,
                                  language: _language,
                                  openLabel: _copy.openService,
                                  onTap: _selectService,
                                ),
                        ),
                        const SizedBox(height: 30),
                        _SupportNote(copy: _copy),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.copy,
    required this.language,
    required this.onLanguageChanged,
  });

  final _HomeCopy copy;
  final HomeLanguage language;
  final ValueChanged<HomeLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: HomeColors.darkCharcoal,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Stack(
        children: [
          const Positioned(
            right: -46,
            top: -64,
            child: _HeaderCircle(size: 180, opacity: 0.14),
          ),
          const Positioned(
            left: -38,
            bottom: -76,
            child: _HeaderCircle(size: 140, opacity: 0.08),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final textScale = MediaQuery.textScalerOf(context)
                          .scale(1);
                      final stackControls =
                          constraints.maxWidth < 390 || textScale > 1.25;

                      final logo = Semantics(
                        label: copy.logoSemantics,
                        image: true,
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 285),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: HomeColors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: HomeColors.missionBlue.withValues(
                                alpha: 0.45,
                              ),
                            ),
                          ),
                          child: Image.asset(
                            'assets/logo.jpg',
                            height: 42,
                            fit: BoxFit.contain,
                            excludeFromSemantics: true,
                            errorBuilder: (_, _, _) => Text(
                              'First Refuge Ministries',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: HomeColors.darkCharcoal,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                        ),
                      );

                      final selector = _LanguageSelector(
                        language: language,
                        copy: copy,
                        onChanged: onLanguageChanged,
                      );

                      if (stackControls) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            logo,
                            const SizedBox(height: 16),
                            selector,
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: logo,
                            ),
                          ),
                          const SizedBox(width: 16),
                          selector,
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCircle extends StatelessWidget {
  const _HeaderCircle({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: HomeColors.missionBlue.withValues(alpha: opacity),
        ),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector({
    required this.language,
    required this.copy,
    required this.onChanged,
  });

  final HomeLanguage language;
  final _HomeCopy copy;
  final ValueChanged<HomeLanguage> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: copy.languageLabel,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: HomeColors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: HomeColors.white.withValues(alpha: 0.18)),
        ),
        child: Wrap(
          spacing: 0,
          runSpacing: 4,
          children: [
            _LanguageOption(
              key: const Key('language-en'),
              label: 'English',
              selected: language == HomeLanguage.english,
              onTap: () => onChanged(HomeLanguage.english),
            ),
            _LanguageOption(
              key: const Key('language-es'),
              label: 'Español',
              selected: language == HomeLanguage.spanish,
              onTap: () => onChanged(HomeLanguage.spanish),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? HomeColors.missionBlue : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44, minWidth: 76),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: HomeColors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection({required this.copy});

  final _HomeCopy copy;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: HomeColors.lightBlue,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            copy.eyebrow,
            style: textTheme.labelLarge?.copyWith(
              color: HomeColors.deepBlue,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.7,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          copy.heading,
          style: textTheme.displaySmall?.copyWith(
            color: HomeColors.darkCharcoal,
            fontWeight: FontWeight.w800,
            height: 1.08,
            letterSpacing: -1.1,
          ),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Text(
            copy.welcome,
            style: textTheme.bodyLarge?.copyWith(
              color: HomeColors.mutedText,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }
}

class _ServicesHeading extends StatelessWidget {
  const _ServicesHeading({required this.copy, required this.resultCount});

  final _HomeCopy copy;
  final int resultCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            copy.servicesHeading,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: HomeColors.darkCharcoal,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Semantics(
          liveRegion: true,
          child: Text(
            copy.resultCount(resultCount),
            key: const Key('service-result-count'),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: HomeColors.deepBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.copy,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final _HomeCopy copy;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const Key('service-search-field'),
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: copy.searchHint,
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                key: const Key('service-search-clear'),
                tooltip: copy.clearSearch,
                onPressed: onClear,
                icon: const Icon(Icons.close_rounded),
              ),
        filled: true,
        fillColor: HomeColors.lightBlue.withValues(alpha: 0.65),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: HomeColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: HomeColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: HomeColors.missionBlue, width: 2),
        ),
      ),
    );
  }
}

class _ServiceGrid extends StatelessWidget {
  const _ServiceGrid({
    super.key,
    required this.services,
    required this.language,
    required this.openLabel,
    required this.onTap,
  });

  final List<_ServiceDefinition> services;
  final HomeLanguage language;
  final String openLabel;
  final ValueChanged<HomeServiceType> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textScale = MediaQuery.textScalerOf(context).scale(1);
        final columns = constraints.maxWidth >= 350 && textScale <= 1.3 ? 2 : 1;
        final itemWidth =
            (constraints.maxWidth - ((columns - 1) * 14)) / columns;
        final baseExtent = itemWidth >= 300 && textScale <= 1.3 ? 212.0 : 252.0;
        final itemExtent = baseExtent + ((textScale - 1).clamp(0, 1) * 132);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: services.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            mainAxisExtent: itemExtent,
          ),
          itemBuilder: (context, index) {
            final service = services[index];
            return _ServiceCard(
              key: Key('service-card-${service.type.name}'),
              service: service,
              language: language,
              openLabel: openLabel,
              onTap: () => onTap(service.type),
            );
          },
        );
      },
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    super.key,
    required this.service,
    required this.language,
    required this.openLabel,
    required this.onTap,
  });

  final _ServiceDefinition service;
  final HomeLanguage language;
  final String openLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final serviceCopy = service.copy[language]!;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      label: '${serviceCopy.title}. ${serviceCopy.subtitle}',
      hint: openLabel,
      child: Material(
        color: HomeColors.white,
        elevation: 0,
        shadowColor: HomeColors.deepBlue.withValues(alpha: 0.16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: HomeColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: HomeColors.missionBlue.withValues(alpha: 0.12),
          highlightColor: HomeColors.lightBlue.withValues(alpha: 0.55),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: HomeColors.lightBlue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        service.icon,
                        color: HomeColors.deepBlue,
                        size: 26,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: HomeColors.darkCharcoal,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: HomeColors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  serviceCopy.title,
                  style: textTheme.titleMedium?.copyWith(
                    color: HomeColors.darkCharcoal,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  serviceCopy.subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: HomeColors.mutedText,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({super.key, required this.copy});

  final _HomeCopy copy;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        color: HomeColors.lightBlue.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: HomeColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            color: HomeColors.deepBlue,
            size: 42,
          ),
          const SizedBox(height: 12),
          Text(
            copy.emptyTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: HomeColors.darkCharcoal,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            copy.emptyBody,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: HomeColors.mutedText),
          ),
        ],
      ),
    );
  }
}

class _SupportNote extends StatelessWidget {
  const _SupportNote({required this.copy});

  final _HomeCopy copy;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: HomeColors.darkCharcoal,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.favorite_rounded,
            color: HomeColors.missionBlue,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              copy.supportNote,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: HomeColors.white,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeCopy {
  const _HomeCopy({
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

  String resultCount(int count) =>
      '$count ${count == 1 ? serviceSingular : servicePlural}';
}

class _ServiceCopy {
  const _ServiceCopy(this.title, this.subtitle);

  final String title;
  final String subtitle;
}

class _ServiceDefinition {
  const _ServiceDefinition({
    required this.type,
    required this.icon,
    required this.copy,
    required this.keywords,
  });

  final HomeServiceType type;
  final IconData icon;
  final Map<HomeLanguage, _ServiceCopy> copy;
  final List<String> keywords;
}

const _copies = <HomeLanguage, _HomeCopy>{
  HomeLanguage.english: _HomeCopy(
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
  ),
  HomeLanguage.spanish: _HomeCopy(
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
  ),
};

const _services = <_ServiceDefinition>[
  _ServiceDefinition(
    type: HomeServiceType.medicalCare,
    icon: Icons.medical_services_rounded,
    copy: {
      HomeLanguage.english: _ServiceCopy(
        'Medical Care',
        'Compassionate health services for our community.',
      ),
      HomeLanguage.spanish: _ServiceCopy(
        'Atención médica',
        'Servicios de salud compasivos para nuestra comunidad.',
      ),
    },
    keywords: [
      'medical',
      'health',
      'doctor',
      'clinic',
      'medicine',
      'médico',
      'salud',
      'doctor',
      'clínica',
    ],
  ),
  _ServiceDefinition(
    type: HomeServiceType.dentalCare,
    icon: Icons.health_and_safety_rounded,
    copy: {
      HomeLanguage.english: _ServiceCopy(
        'Dental Care',
        'Essential oral care to help you smile with confidence.',
      ),
      HomeLanguage.spanish: _ServiceCopy(
        'Atención dental',
        'Cuidado bucal esencial para sonreír con confianza.',
      ),
    },
    keywords: [
      'dental',
      'dentist',
      'teeth',
      'tooth',
      'oral',
      'diente',
      'dentista',
      'boca',
    ],
  ),
  _ServiceDefinition(
    type: HomeServiceType.counseling,
    icon: Icons.forum_rounded,
    copy: {
      HomeLanguage.english: _ServiceCopy(
        'Counseling',
        'A caring space for emotional and spiritual support.',
      ),
      HomeLanguage.spanish: _ServiceCopy(
        'Consejería',
        'Un espacio de apoyo emocional y espiritual.',
      ),
    },
    keywords: [
      'counseling',
      'counselling',
      'mental',
      'emotional',
      'talk',
      'therapy',
      'consejería',
      'emocional',
      'terapia',
    ],
  ),
  _ServiceDefinition(
    type: HomeServiceType.foodPantry,
    icon: Icons.shopping_basket_rounded,
    copy: {
      HomeLanguage.english: _ServiceCopy(
        'Food Pantry',
        'Fresh groceries and pantry staples for your household.',
      ),
      HomeLanguage.spanish: _ServiceCopy(
        'Despensa de alimentos',
        'Alimentos frescos y básicos para su hogar.',
      ),
    },
    keywords: [
      'food',
      'pantry',
      'groceries',
      'meals',
      'hunger',
      'alimentos',
      'comida',
      'despensa',
    ],
  ),
  _ServiceDefinition(
    type: HomeServiceType.volunteerOpportunities,
    icon: Icons.volunteer_activism_rounded,
    copy: {
      HomeLanguage.english: _ServiceCopy(
        'Volunteer Opportunities',
        'Share your time and talents with neighbors in need.',
      ),
      HomeLanguage.spanish: _ServiceCopy(
        'Oportunidades de voluntariado',
        'Comparta su tiempo y talento con quienes lo necesitan.',
      ),
    },
    keywords: [
      'volunteer',
      'serve',
      'help',
      'give',
      'community',
      'voluntario',
      'servir',
      'ayudar',
    ],
  ),
  _ServiceDefinition(
    type: HomeServiceType.myAppointments,
    icon: Icons.calendar_month_rounded,
    copy: {
      HomeLanguage.english: _ServiceCopy(
        'My Appointments',
        'View and manage your upcoming visits in one place.',
      ),
      HomeLanguage.spanish: _ServiceCopy(
        'Mis citas',
        'Vea y administre sus próximas visitas en un solo lugar.',
      ),
    },
    keywords: [
      'appointment',
      'appointments',
      'booking',
      'schedule',
      'visit',
      'cita',
      'citas',
      'horario',
      'visita',
    ],
  ),
];
