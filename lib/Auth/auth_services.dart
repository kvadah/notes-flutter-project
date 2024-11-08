import 'package:notes/Auth/auth_provider.dart';
import 'package:notes/Auth/auth_user.dart';

class AuthServise implements AuthProviders {
  @override
  final AuthProviders provider;

  AuthServise({required this.provider});
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(email: email, password: password);

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => provider.currentUser;


  @override
  Future<void> logOut()=>
      provider.logOut();


  @override
  Future<AuthUser> login({required String email, required String password})=>
      provider.login(email: email, password: password);


  @override
  Future<void> sendVertificationEmail() =>
      provider.sendVertificationEmail();
}
