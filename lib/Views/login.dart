// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notes/Auth/auth_exception.dart';
import 'package:notes/Auth/auth_services.dart';
import 'package:notes/Utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // text editor controllers for user inpt email and password
  late final TextEditingController _email;
  late final TextEditingController _password;
  final List<String> adsText = [
    "Write your Notes!",
    "Keep Your Notes Secure",
    "Back Up your Notes with Cloud"
  ];

  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % adsText.length;
      });
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 40),
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.note,
                color: Colors.white,
                size: 50,
              ),
            ),
            // email text field
            Container(
              margin: EdgeInsets.only(bottom: 10, right: 15, left: 15),
              child: TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email, color: Colors.black),
                  hintText: ('Email'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.black, // Border color
                      width: 1.1, // Border thickness
                    ),
                  ),
                ),
              ),
            ),
            //password text field
            Container(
              margin: const EdgeInsets.only(bottom: 10, right: 15, left: 15),
              child: TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.black,
                  ),
                  hintText: ('Password'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.black, // Border color
                      width: 1.1, // Border thickness
                    ),
                  ),
                ),
              ),
            ),
            //login text Button
            SizedBox(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;

                    try {
                      // signin user in firebase  with inputed email and password
                      // final currentUser = AuthService.firebase().currentUser;
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
            ),
            // text button to navigate to a register view
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/register', (route) => false);
                },
                child: const Text("don't have anaccount? Register here"))
          ],
        ),
      ),
    );
  }
}
