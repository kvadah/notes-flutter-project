import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email, password: password);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found')
                    ;
                  else if (e.code == 'wrong-password') ;
                }
                User? user = FirebaseAuth.instance.currentUser;
                if (user?.emailVerified ?? false) {
                  Fluttertoast.showToast(
                        msg: 'Email is verified',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                    );
                }
              },
              child: const Text('Login')),
               TextButton(
            onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil('/register',(route)=>false);
            }, 
          child: const Text("don't have anaccount? Register here"))
        ],
      ),
    );
  }
}
