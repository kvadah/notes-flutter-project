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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 233, 189, 109), // Start color
              Color.fromARGB(255, 134, 210, 245), // End color
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 80, top: 35),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 11, left: 15, right: 10),
                  child: TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.black,
                      ),
                      hintText: ('Email'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                          color: Colors.blue, // Border color
                          width: 1.1, // Border thickness
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 11, left: 15, right: 10),
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
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                          color: Colors.blue, // Border color
                          width: 1.1, // Border thickness
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
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
                ),
                Container(
                  margin: EdgeInsets.only(top: 18),
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login', (route) => false);
                      },
                      child: const Text(
                        'already registered? login here',
                        style: TextStyle(
                          color: Color.fromARGB(255, 27, 12, 231),
                        ),
                      )),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 25),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '© 2024 Khalid plc. All Rights Reserved.',
                    style: TextStyle(
                      color: Colors.black.withOpacity(1),
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
