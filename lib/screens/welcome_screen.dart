import 'package:flutter/material.dart';

import '../navigation.dart' show HomePage;
import '../services/auth_service.dart';

enum AuthView {
  signIn,
  createAccount,
  forgotPassword,
  confirmSignUp,
  confirmResetPassword,
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _confirmationCodeController = TextEditingController();
  AuthView _view = AuthView.signIn;
  bool _hidePassword = true;
  bool _isSignedIn = false;
  bool _checkingSession = true;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final signedIn = await _authService.isSignedIn();

    if (!mounted) return;

    setState(() {
      _isSignedIn = signedIn;
      _checkingSession = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _confirmationCodeController.dispose();
    super.dispose();
  }

  String get _title => switch (_view) {
    AuthView.signIn => 'Welcome back',
    AuthView.createAccount => 'Create your account',
    AuthView.forgotPassword => 'Reset your password',
    AuthView.confirmSignUp => 'Verify your email',
    AuthView.confirmResetPassword => 'Create a new password',
  };

  String get _subtitle => switch (_view) {
    AuthView.signIn => 'Sign in to continue to your account.',
    AuthView.createAccount => 'A few details and you’ll be ready to go.',
    AuthView.forgotPassword =>
      'Enter the email address associated with your account.',
    AuthView.confirmSignUp => 'Enter the verification code sent to your email.',
    AuthView.confirmResetPassword =>
      'Enter the code from your email and choose a new password.',
  };

  String get _submitLabel => switch (_view) {
    AuthView.signIn => 'Sign in',
    AuthView.createAccount => 'Create account',
    AuthView.forgotPassword => 'Send reset instructions',
    AuthView.confirmSignUp => 'Verify account',
    AuthView.confirmResetPassword => 'Reset password',
  };

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    AppAuthResult result;
    switch (_view) {
      case AuthView.signIn:
        result = await _authService.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        break;

      case AuthView.createAccount:
        result = await _authService.createAccount(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        break;

      case AuthView.forgotPassword:
        result = await _authService.resetPassword(
          email: _emailController.text.trim(),
        );
        break;

      case AuthView.confirmSignUp:
        result = await _authService.confirmSignUp(
          email: _emailController.text.trim(),
          code: _confirmationCodeController.text.trim(),
        );
        break;

      case AuthView.confirmResetPassword:
        result = await _authService.confirmResetPassword(
          email: _emailController.text.trim(),
          newPassword: _passwordController.text,
          confirmationCode: _confirmationCodeController.text.trim(),
        );
        break;
    }
    if (!mounted) return;
    if (_view == AuthView.forgotPassword && result.success) {
      setState(() {
        _view = AuthView.confirmResetPassword;
        _confirmationCodeController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
      });
    } else if (result.requiresConfirmation) {
      setState(() {
        _view = AuthView.confirmSignUp;
        _confirmationCodeController.clear();
      });
    } else if (_view == AuthView.confirmSignUp && result.success) {
      setState(() {
        _view = AuthView.signIn;
        _confirmationCodeController.clear();
      });
    } else if (_view == AuthView.confirmResetPassword && result.success) {
      setState(() {
        _view = AuthView.signIn;
        _confirmationCodeController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
      });
    } else if (_view == AuthView.signIn && result.success) {
      setState(() {
        _isSignedIn = true;
      });
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(result.message)));
  }

  void _openNavigation() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const HomePage()),
    );
  }

  Future<void> _resendConfirmationCode() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your email address first.')),
      );
      return;
    }

    final result = await _authService.resendSignUpCode(email: email);

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(result.message)));
  }

  Future<void> _signOut() async {
    final result = await _authService.signOut();

    if (!mounted) return;

    if (result.success) {
      setState(() {
        _isSignedIn = false;
        _view = AuthView.signIn;
        _passwordController.clear();
        _confirmPasswordController.clear();
      });
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(result.message)));
  }

  void _setView(AuthView view) {
    setState(() {
      _view = view;
      _formKey.currentState?.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingSession) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_isSignedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('First Refuge Ministries')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline, size: 72),
              const SizedBox(height: 20),
              const Text(
                'You are signed in!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Temporary home screen'),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _signOut,
                icon: const Icon(Icons.logout),
                label: const Text('Sign out'),
              ),
            ],
          ),
        ),
      );
    }

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
                                    if (_view == AuthView.confirmSignUp ||
                                        _view ==
                                            AuthView.confirmResetPassword) ...[
                                      const SizedBox(height: 18),
                                      _fieldLabel('Verification code'),
                                      TextFormField(
                                        controller: _confirmationCodeController,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.done,
                                        decoration: const InputDecoration(
                                          hintText: 'Enter verification code',
                                          prefixIcon: Icon(
                                            Icons.verified_user_outlined,
                                          ),
                                        ),
                                        validator: (value) {
                                          final code = value?.trim() ?? '';
                                          if (code.isEmpty) {
                                            return 'Enter the verification code';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                    if (_view == AuthView.signIn ||
                                        _view == AuthView.createAccount ||
                                        _view ==
                                            AuthView.confirmResetPassword) ...[
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
                                          if ((_view ==
                                                      AuthView.createAccount ||
                                                  _view ==
                                                      AuthView
                                                          .confirmResetPassword) &&
                                              value.length < 8) {
                                            return 'Use at least 8 characters';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                    if (_view == AuthView.createAccount ||
                                        _view ==
                                            AuthView.confirmResetPassword) ...[
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
                                        onPressed: _view == AuthView.signIn
                                            ? _openNavigation
                                            : _submit,
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
                                    if (_view == AuthView.confirmSignUp) ...[
                                      const SizedBox(height: 12),
                                      TextButton(
                                        onPressed: _resendConfirmationCode,
                                        child: const Text(
                                          'Resend verification code',
                                        ),
                                      ),
                                    ],
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
