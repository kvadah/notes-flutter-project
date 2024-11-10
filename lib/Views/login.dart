// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:notes/Auth/auth_exception.dart';
import 'package:notes/Auth/auth_services.dart';
import 'package:notes/Views/utilitis.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // text editor controllers for user inpt email and password
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
        title: const Text('Login'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        children: [
          // email text field
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: ('Email'),
            ),
          ),
          //password text field
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: ('Password'),
            ),
          ),
          //login text Button
          TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.lightBlue,
              ),
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;

                try {
                  // signin user in firebase  with inputed email and password
                  await AuthService.firebase().login(
                    email: email,
                    password: password,
                  );
                  if (mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/notes',
                      (route) => false,
                    );
                  }
                } on InvalidEmailAuthException {
                  await showErrorDialog(context, 'Invalid Email');
                } on InvalidCredentialAuthException {
                  await showErrorDialog(context, "Wrong Email or Password");
                } on GenericAuthException {
                  await showErrorDialog(context, "Failed to login");
                }
               
              },
              child: const Text('Login')),
          // text button to navigate to a register view
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/register', (route) => false);
              },
              child: const Text("don't have anaccount? Register here"))
        ],
      ),
    );
  }
}
