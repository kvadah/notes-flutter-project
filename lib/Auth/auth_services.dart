
import 'package:notes/Auth/auth_provider.dart';
import 'package:notes/Auth/auth_user.dart';
import 'package:notes/Auth/firebase_auth_provider.dart';

class AuthService implements AuthProviders {
  final AuthProviders provider;
  AuthService({required this.provider});
  factory AuthService.firebase()=>AuthService(provider: FirebaseAuthProvider());
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<AuthUser> login({required String email, required String password}) =>
      provider.login(email: email, password: password);

  @override
  Future<void> sendVertificationEmail() => provider.sendVertificationEmail();

  @override
  Future<void> initialize() => provider.initialize();
}
