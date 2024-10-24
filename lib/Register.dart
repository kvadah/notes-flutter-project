import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/firebase_options.dart';

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
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email, password: password);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'email-already=in-use')
                    ;
                  else if (e.code == 'invalid-email')
                    ;
                  else if (e.code == 'weak-password') ;
                }
              },
              child: const Text('Register')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/login',(route)=>false);
            }, 
          child: const Text('already registered? login here'))
        ],
      ),
    );
  }
}
