import 'package:notes/Auth/auth_user.dart';

abstract class AuthProviders {
  AuthUser? get currentUser;
  Future<void> initialize();
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<AuthUser> login({
    required String email,
    required String password,
  });
  Future<void> sendVertificationEmail();
  Future<void> logOut();
}
