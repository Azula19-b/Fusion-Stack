import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/home_service_type.dart';

export '../l10n/app_localizations.dart' show HomeLanguage;
export '../models/home_service_type.dart';

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

  AppLocalizations get _copy => AppLocalizations.of(_language);

  List<_ServiceDefinition> get _filteredServices {
    final query = _normalize(_query);
    if (query.isEmpty) return _services;

    return _services.where((service) {
      final localized = _copy.services[service.type]!;
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

  final AppLocalizations copy;
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Semantics(
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
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      _LanguageSelector(
                        language: language,
                        copy: copy,
                        onChanged: onLanguageChanged,
                      ),
                    ],
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
  final AppLocalizations copy;
  final ValueChanged<HomeLanguage> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: copy.languageLabel,
      button: true,
      child: PopupMenuButton<HomeLanguage>(
        key: const Key('language-selector'),
        tooltip: copy.languageLabel,
        offset: const Offset(0, 48),
        onSelected: onChanged,
        itemBuilder: (context) => [
          PopupMenuItem(
            key: const Key('language-en'),
            value: HomeLanguage.english,
            child: Row(
              children: [
                _LanguageFlag(
                  assetName: 'assets/usFlag.png',
                  imageKey: const Key('language-option-flag-en'),
                  size: 26,
                ),
                const SizedBox(width: 12),
                const Text('English'),
                if (language == HomeLanguage.english) ...[
                  const Spacer(),
                  const Icon(Icons.check, size: 18),
                ],
              ],
            ),
          ),
          PopupMenuItem(
            key: const Key('language-es'),
            value: HomeLanguage.spanish,
            child: Row(
              children: [
                _LanguageFlag(
                  assetName: 'assets/mexFlag.png',
                  imageKey: const Key('language-option-flag-es'),
                  size: 26,
                ),
                const SizedBox(width: 12),
                const Text('Español'),
                if (language == HomeLanguage.spanish) ...[
                  const Spacer(),
                  const Icon(Icons.check, size: 18),
                ],
              ],
            ),
          ),
        ],
        child: Container(
          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: HomeColors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: HomeColors.white.withValues(alpha: 0.18)),
          ),
          child: _LanguageFlag(
            assetName: language == HomeLanguage.english
                ? 'assets/usFlag.png'
                : 'assets/mexFlag.png',
            imageKey: const Key('language-selected-flag'),
            size: 28,
          ),
        ),
      ),
    );
  }
}

class _LanguageFlag extends StatelessWidget {
  const _LanguageFlag({
    required this.assetName,
    required this.imageKey,
    required this.size,
  });

  final String assetName;
  final Key imageKey;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        assetName,
        key: imageKey,
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection({required this.copy});

  final AppLocalizations copy;

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

  final AppLocalizations copy;
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
  final AppLocalizations copy;
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
    final serviceCopy =
        AppLocalizations.of(language).services[service.type]!;
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

  final AppLocalizations copy;

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

  final AppLocalizations copy;

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
        crossAxisAlignment: CrossAxisAlignment.center,
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

class _ServiceDefinition {
  const _ServiceDefinition({
    required this.type,
    required this.icon,
    required this.keywords,
  });

  final HomeServiceType type;
  final IconData icon;
  final List<String> keywords;
}

const _services = <_ServiceDefinition>[
  _ServiceDefinition(
    type: HomeServiceType.medicalCare,
    icon: Icons.medical_services_rounded,
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
