import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF14243A);
    const blue = Color(0xFF315FEA);

    return MaterialApp(
      title: 'Welcome',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: blue,
          primary: blue,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7FC),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF7F9FC),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 17,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: blue, width: 1.5),
          ),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: navy,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.7,
          ),
          bodyMedium: TextStyle(color: Color(0xFF68768A)),
        ),
      ),
      home: const AuthPage(),
    );
  }
}

enum AuthView { signIn, createAccount, forgotPassword }

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  AuthView _view = AuthView.signIn;
  bool _hidePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String get _title => switch (_view) {
    AuthView.signIn => 'Welcome back',
    AuthView.createAccount => 'Create your account',
    AuthView.forgotPassword => 'Reset your password',
  };

  String get _subtitle => switch (_view) {
    AuthView.signIn => 'Sign in to continue to your account.',
    AuthView.createAccount => 'A few details and you’ll be ready to go.',
    AuthView.forgotPassword =>
      'Enter the email address associated with your account.',
  };

  String get _submitLabel => switch (_view) {
    AuthView.signIn => 'Sign in',
    AuthView.createAccount => 'Create account',
    AuthView.forgotPassword => 'Send reset instructions',
  };

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Form validated. Connect an authentication service to continue.',
        ),
      ),
    );
  }

  void _setView(AuthView view) {
    setState(() {
      _view = view;
      _formKey.currentState?.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF7F9FF), Color(0xFFEAF0FF)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 28,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 840),
                      child: Card(
                        elevation: 12,
                        shadowColor: const Color(0x1A1C3470),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                          side: const BorderSide(color: Color(0xFFEAF0F7)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 32, 30, 28),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(1),
                                child: Image.asset(
                                  'assets/logo.jpg',
                                  width: 323,
                                  height: 58,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        width: 68,
                                        height: 68,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEEF2FF),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.auto_awesome_rounded,
                                          color: Color(0xFF315FEA),
                                          size: 32,
                                        ),
                                      ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                _title,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _subtitle,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 28),
                              if (_view != AuthView.forgotPassword)
                                _buildViewSelector(),
                              const SizedBox(height: 22),
                              Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    if (_view == AuthView.createAccount) ...[
                                      _fieldLabel('Full name'),
                                      TextFormField(
                                        controller: _nameController,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        textInputAction: TextInputAction.next,
                                        decoration: const InputDecoration(
                                          hintText: 'Your name',
                                          prefixIcon: Icon(
                                            Icons.person_outline_rounded,
                                          ),
                                        ),
                                        validator: (value) =>
                                            value == null ||
                                                value.trim().isEmpty
                                            ? 'Enter your name'
                                            : null,
                                      ),
                                      const SizedBox(height: 18),
                                    ],
                                    _fieldLabel('Email address'),
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction:
                                          _view == AuthView.forgotPassword
                                          ? TextInputAction.done
                                          : TextInputAction.next,
                                      decoration: const InputDecoration(
                                        hintText: 'you@example.com',
                                        prefixIcon: Icon(
                                          Icons.mail_outline_rounded,
                                        ),
                                      ),
                                      validator: (value) {
                                        final email = value?.trim() ?? '';
                                        if (email.isEmpty) {
                                          return 'Enter your email address';
                                        }
                                        if (!RegExp(
                                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                        ).hasMatch(email)) {
                                          return 'Enter a valid email address';
                                        }
                                        return null;
                                      },
                                    ),
                                    if (_view != AuthView.forgotPassword) ...[
                                      const SizedBox(height: 18),
                                      _fieldLabel('Password'),
                                      TextFormField(
                                        controller: _passwordController,
                                        obscureText: _hidePassword,
                                        textInputAction:
                                            _view == AuthView.signIn
                                            ? TextInputAction.done
                                            : TextInputAction.next,
                                        decoration: InputDecoration(
                                          hintText: 'Enter your password',
                                          prefixIcon: const Icon(
                                            Icons.lock_outline_rounded,
                                          ),
                                          suffixIcon: IconButton(
                                            tooltip: _hidePassword
                                                ? 'Show password'
                                                : 'Hide password',
                                            onPressed: () => setState(
                                              () => _hidePassword =
                                                  !_hidePassword,
                                            ),
                                            icon: Icon(
                                              _hidePassword
                                                  ? Icons.visibility_outlined
                                                  : Icons
                                                        .visibility_off_outlined,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Enter your password';
                                          }
                                          if (_view == AuthView.createAccount &&
                                              value.length < 8) {
                                            return 'Use at least 8 characters';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                    if (_view == AuthView.createAccount) ...[
                                      const SizedBox(height: 18),
                                      _fieldLabel('Confirm password'),
                                      TextFormField(
                                        controller: _confirmPasswordController,
                                        obscureText: true,
                                        textInputAction: TextInputAction.done,
                                        decoration: const InputDecoration(
                                          hintText: 'Enter your password again',
                                          prefixIcon: Icon(
                                            Icons.lock_outline_rounded,
                                          ),
                                        ),
                                        validator: (value) =>
                                            value != _passwordController.text
                                            ? 'Passwords do not match'
                                            : null,
                                      ),
                                    ],
                                    if (_view == AuthView.signIn) ...[
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () =>
                                              _setView(AuthView.forgotPassword),
                                          child: const Text('Forgot password?'),
                                        ),
                                      ),
                                    ] else
                                      const SizedBox(height: 18),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      height: 54,
                                      child: FilledButton(
                                        onPressed: _submit,
                                        style: FilledButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF315FEA,
                                          ),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          textStyle: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        child: Text(_submitLabel),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (_view == AuthView.forgotPassword) ...[
                                const SizedBox(height: 12),
                                TextButton.icon(
                                  onPressed: () => _setView(AuthView.signIn),
                                  icon: const Icon(Icons.arrow_back_rounded),
                                  label: const Text('Back to sign in'),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildViewSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _viewTab('Sign in', AuthView.signIn),
          _viewTab('Create account', AuthView.createAccount),
        ],
      ),
    );
  }

  Widget _viewTab(String label, AuthView view) {
    final selected = _view == view;
    return Expanded(
      child: GestureDetector(
        onTap: () => _setView(view),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0x100D214A),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected
                  ? const Color(0xFF243750)
                  : const Color(0xFF7A8799),
              fontSize: 13,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF293A50),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
