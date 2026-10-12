class AuthResult {
  final bool success;
  final String message;

  const AuthResult({required this.success, required this.message});
}

class AuthService {
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    return const AuthResult(
      success: false,
      message: 'Authentication backend is not connected yet.',
    );
  }

  Future<AuthResult> createAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    return const AuthResult(
      success: false,
      message: 'Authentication backend is not connected yet.',
    );
  }

  Future<AuthResult> resetPassword({required String email}) async {
    return const AuthResult(
      success: false,
      message: 'Password reset is not connected yet.',
    );
  }
}
