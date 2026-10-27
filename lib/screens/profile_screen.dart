import 'package:flutter/material.dart';

import '../models/profile_data.dart';
import 'home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    this.onBack,
    this.onSignOut,
    this.initialLanguage = HomeLanguage.english,
    this.onLanguageChanged,
  });

  final VoidCallback? onBack;
  final Future<void> Function()? onSignOut;
  final HomeLanguage initialLanguage;
  final ValueChanged<HomeLanguage>? onLanguageChanged;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  late ProfileData _profile;
  late HomeLanguage _draftLanguage;
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _profile = ProfileData(
      displayName: 'Demo User',
      email: 'demo@example.com',
      phone: '(940) 555-0100',
      preferredLanguage: widget.initialLanguage,
    );
    _draftLanguage = _profile.preferredLanguage;
    _loadDraft();
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing && oldWidget.initialLanguage != widget.initialLanguage) {
      _profile = ProfileData(
        displayName: _profile.displayName,
        email: _profile.email,
        phone: _profile.phone,
        preferredLanguage: widget.initialLanguage,
      );
      _draftLanguage = widget.initialLanguage;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _loadDraft() {
    _nameController.text = _profile.displayName;
    _emailController.text = _profile.email;
    _phoneController.text = _profile.phone;
    _draftLanguage = _profile.preferredLanguage;
  }

  void _startEditing() {
    _loadDraft();
    setState(() => _isEditing = true);
  }

  void _cancelEditing() {
    FocusScope.of(context).unfocus();
    _loadDraft();
    _formKey.currentState?.reset();
    setState(() => _isEditing = false);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Your changes were not saved.')),
      );
  }

  Future<void> _saveProfile() async {
    if (_isSaving || !_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;

    setState(() {
      _profile = ProfileData(
        displayName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        preferredLanguage: _draftLanguage,
      );
      _isEditing = false;
      _isSaving = false;
    });
    widget.onLanguageChanged?.call(_profile.preferredLanguage);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Demo profile updated for this app session. Nothing was sent to a server.',
          ),
        ),
      );
  }

  String? _requiredName(String? value) {
    if ((value ?? '').trim().isEmpty) return 'Enter your display name.';
    return null;
  }

  String? _validateEmail(String? value) {
    final email = (value ?? '').trim();
    if (email.isEmpty) return 'Enter your email address.';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final phone = (value ?? '').trim();
    if (phone.isEmpty) return null;
    final digitCount = RegExp(r'\d').allMatches(phone).length;
    if (digitCount < 10) return 'Enter a phone number with at least 10 digits.';
    return null;
  }

  String get _initials {
    final parts = _profile.displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    return parts.take(2).map((part) => part[0].toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.white,
      body: SafeArea(
        bottom: false,
        child: ListView(
          key: const Key('profile-screen'),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            _ScreenHeader(
              title: 'My Profile',
              subtitle: 'Review and update your personal details.',
              onBack: widget.onBack,
            ),
            const SizedBox(height: 20),
            const _DemoNotice(),
            const SizedBox(height: 24),
            _ProfileHero(initials: _initials, name: _profile.displayName),
            const SizedBox(height: 24),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _isEditing ? _buildEditForm() : _buildProfileDetails(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetails() {
    return Column(
      key: const ValueKey('profile-view'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionCard(
          title: 'Profile information',
          children: [
            _InfoRow(
              icon: Icons.badge_outlined,
              label: 'Display name',
              value: _profile.displayName,
            ),
            _InfoRow(
              icon: Icons.mail_outline_rounded,
              label: 'Email address',
              value: _profile.email,
            ),
            _InfoRow(
              icon: Icons.phone_outlined,
              label: 'Phone number',
              value: _profile.phone.isEmpty ? 'Not provided' : _profile.phone,
            ),
            _InfoRow(
              icon: Icons.language_rounded,
              label: 'Preferred language',
              value: _profile.preferredLanguage == HomeLanguage.english
                  ? 'English'
                  : 'Español',
              showDivider: false,
            ),
          ],
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 52,
          child: FilledButton.icon(
            key: const Key('edit-profile-button'),
            onPressed: _startEditing,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Edit Profile'),
          ),
        ),
        if (widget.onSignOut != null) ...[
          const SizedBox(height: 10),
          SizedBox(
            height: 48,
            child: OutlinedButton.icon(
              onPressed: widget.onSignOut,
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Sign Out'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey('profile-edit'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionCard(
            title: 'Edit profile information',
            children: [
              TextFormField(
                key: const Key('profile-name-field'),
                controller: _nameController,
                validator: _requiredName,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                decoration: const InputDecoration(
                  labelText: 'Display name',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('profile-email-field'),
                controller: _emailController,
                validator: _validateEmail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                decoration: const InputDecoration(
                  labelText: 'Email address',
                  prefixIcon: Icon(Icons.mail_outline_rounded),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('profile-phone-field'),
                controller: _phoneController,
                validator: _validatePhone,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.telephoneNumber],
                decoration: const InputDecoration(
                  labelText: 'Phone number (optional)',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<HomeLanguage>(
                key: const Key('profile-language-field'),
                initialValue: _draftLanguage,
                decoration: const InputDecoration(
                  labelText: 'Preferred language',
                  prefixIcon: Icon(Icons.language_rounded),
                ),
                items: const [
                  DropdownMenuItem(
                    value: HomeLanguage.english,
                    child: Text('English'),
                  ),
                  DropdownMenuItem(
                    value: HomeLanguage.spanish,
                    child: Text('Español'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _draftLanguage = value);
                },
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 52,
            child: FilledButton.icon(
              key: const Key('save-profile-button'),
              onPressed: _isSaving ? null : _saveProfile,
              icon: _isSaving
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_rounded),
              label: Text(_isSaving ? 'Saving…' : 'Save Changes'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 48,
            child: TextButton(
              key: const Key('cancel-profile-button'),
              onPressed: _isSaving ? null : _cancelEditing,
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScreenHeader extends StatelessWidget {
  const _ScreenHeader({
    required this.title,
    required this.subtitle,
    this.onBack,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (onBack != null) ...[
          IconButton.filledTonal(
            key: const Key('profile-back-button'),
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
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: HomeColors.darkCharcoal,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
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

class _DemoNotice extends StatelessWidget {
  const _DemoNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: HomeColors.lightBlue,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HomeColors.border),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: HomeColors.deepBlue),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Demo profile — changes are kept only while this app is open and are not sent to a server.',
              style: TextStyle(color: HomeColors.darkCharcoal, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.initials, required this.name});

  final String initials;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 46,
          backgroundColor: HomeColors.missionBlue,
          foregroundColor: HomeColors.white,
          child: Text(
            initials,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: HomeColors.darkCharcoal,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: HomeColors.darkCharcoal,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: HomeColors.lightBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: HomeColors.deepBlue, size: 22),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelMedium
                        ?.copyWith(color: HomeColors.mutedText),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: HomeColors.darkCharcoal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (showDivider) ...[
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),
        ],
      ],
    );
  }
}
