import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/Auth/auth_provider.dart';
import 'package:notes/Auth/auth_exception.dart';
import 'package:notes/Auth/auth_user.dart';

class FirebaseAuthProvider implements AuthProviders {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw userNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw emailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw invalidEmailAuthException();
      } else if (e.code == 'weak-password') {
        throw weakPasswordAuthException();
      }
    } catch (e) {
      throw genericAuthException();
    }
    throw genericAuthException();
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw userNotLoggedInAuthException();
      }
    } on FirebaseAuthException {}
    throw genericAuthException();
  }

  @override
  Future<void> sendVertificationEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw userNotLoggedInAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw userNotLoggedInAuthException();
    }
  }
}
