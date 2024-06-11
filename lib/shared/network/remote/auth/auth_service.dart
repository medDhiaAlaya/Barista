import 'auth.dart';
import 'auth_provider.dart';

class AuthService implements Auth {
  final Auth authProvider;
  const AuthService(this.authProvider);

  factory AuthService.instance() => AuthService(AuthProvider());



  @override
  void initialize() => authProvider.initialize();
}
