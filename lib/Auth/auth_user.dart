import 'package:firebase_auth/firebase_auth.dart' show User;

class AuthUser {
  String? email;
  final bool isEmailVerified;
  AuthUser(
    this.email,
    this.isEmailVerified,
  );
  factory AuthUser.fromFirebase(User user) => AuthUser(user.email,user.emailVerified);
}
