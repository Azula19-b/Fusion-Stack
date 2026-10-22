import 'package:amplify_flutter/amplify_flutter.dart';

class AppAuthResult {
  final bool success;
  final String message;
  final bool requiresConfirmation;

  const AppAuthResult({
    required this.success,
    required this.message,
    this.requiresConfirmation = false,
  });
}

class AuthService {
  Future<AppAuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );

      if (result.isSignedIn) {
        return const AppAuthResult(
          success: true,
          message: 'Signed in successfully.',
        );
      }

      if (result.nextStep.signInStep == AuthSignInStep.confirmSignUp) {
        return const AppAuthResult(
          success: false,
          message: 'Please verify your email to continue.',
          requiresConfirmation: true,
        );
      }

      return AppAuthResult(
        success: false,
        message:
            'Additional sign-in step required: '
            '${result.nextStep.signInStep.name}',
      );
    } on AuthException catch (e) {
      return AppAuthResult(success: false, message: e.message);
    }
  }

  Future<AppAuthResult> createAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final result = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(
          userAttributes: {
            AuthUserAttributeKey.email: email,
            AuthUserAttributeKey.name: name,
          },
        ),
      );

      if (result.isSignUpComplete) {
        return const AppAuthResult(
          success: true,
          message: 'Account created successfully.',
        );
      }

      if (result.nextStep.signUpStep == AuthSignUpStep.confirmSignUp) {
        return const AppAuthResult(
          success: true,
          message:
              'Account created. Check your email for the verification code.',
          requiresConfirmation: true,
        );
      }

      return const AppAuthResult(
        success: false,
        message: 'Additional signup step is required.',
      );
    } on AuthException catch (e) {
      return AppAuthResult(success: false, message: e.message);
    }
  }

  Future<AppAuthResult> resetPassword({required String email}) async {
    try {
      final result = await Amplify.Auth.resetPassword(username: email);

      if (result.nextStep.updateStep ==
          AuthResetPasswordStep.confirmResetPasswordWithCode) {
        return const AppAuthResult(
          success: true,
          message: 'A password reset code was sent to your email.',
        );
      }

      return const AppAuthResult(
        success: true,
        message: 'Password reset request completed.',
      );
    } on AuthException catch (e) {
      return AppAuthResult(success: false, message: e.message);
    }
  }

  Future<AppAuthResult> confirmResetPassword({
    required String email,
    required String newPassword,
    required String confirmationCode,
  }) async {
    try {
      await Amplify.Auth.confirmResetPassword(
        username: email,
        newPassword: newPassword,
        confirmationCode: confirmationCode,
      );

      return const AppAuthResult(
        success: true,
        message: 'Password reset successfully. You can now sign in.',
      );
    } on AuthException catch (e) {
      return AppAuthResult(success: false, message: e.message);
    }
  }

  Future<AppAuthResult> confirmSignUp({
    required String email,
    required String code,
  }) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: code,
      );

      if (result.isSignUpComplete) {
        return const AppAuthResult(
          success: true,
          message: 'Email verified successfully. You can now sign in.',
        );
      }

      return const AppAuthResult(
        success: false,
        message: 'Additional verification is required.',
      );
    } on AuthException catch (e) {
      return AppAuthResult(success: false, message: e.message);
    }
  }

  Future<AppAuthResult> resendSignUpCode({required String email}) async {
    try {
      await Amplify.Auth.resendSignUpCode(username: email);

      return const AppAuthResult(
        success: true,
        message: 'A new verification code was sent to your email.',
      );
    } on AuthException catch (e) {
      return AppAuthResult(success: false, message: e.message);
    }
  }

  Future<bool> isSignedIn() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      return session.isSignedIn;
    } on AuthException {
      return false;
    }
  }

  Future<AppAuthResult> signOut() async {
    try {
      await Amplify.Auth.signOut();

      return const AppAuthResult(
        success: true,
        message: 'Signed out successfully.',
      );
    } on AuthException catch (e) {
      return AppAuthResult(success: false, message: e.message);
    }
  }
}
