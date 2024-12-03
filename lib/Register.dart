// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:notes/Auth/auth_exception.dart';
import 'package:notes/Auth/auth_services.dart';
import 'package:notes/Utilities/show_error_dialog.dart';

class Registerview extends StatefulWidget {
  const Registerview({super.key});

  @override
  State<Registerview> createState() => _RegisterviewState();
}

class _RegisterviewState extends State<Registerview> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: ('Email'),
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: ('Password'),
            ),
          ),
          TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.lightBlue,
              ),
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await AuthService.firebase()
                      .createUser(email: email, password: password);
                  AuthService.firebase().sendVertificationEmail();
                  Navigator.of(context).pushNamed('/verifyEmail');
                } on EmailAlreadyInUseAuthException {
                  await showErrorDialog(
                    context,
                    'this Email is already Registerd',
                  );
                } on InvalidEmailAuthException {
                  await showErrorDialog(
                    context,
                    'Invalid Email Format',
                  );
                } on WeakPasswordAuthException {
                  await showErrorDialog(
                    context,
                    'Use Strong Password',
                  );
                }
              },
              child: const Text('Register')),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false);
              },
              child: const Text('already registered? login here'))
        ],
      ),
    );
  }
}
