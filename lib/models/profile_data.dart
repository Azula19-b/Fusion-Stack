import '../l10n/app_localizations.dart';

class ProfileData {
  const ProfileData({
    required this.displayName,
    required this.email,
    required this.phone,
    required this.preferredLanguage,
  });

  final String displayName;
  final String email;
  final String phone;
  final HomeLanguage preferredLanguage;
}
