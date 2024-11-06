import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/NotesView.dart';
import 'package:notes/Register.dart';
import 'package:notes/Views/EmailVerifyView.dart';
import 'package:notes/Views/login.dart';

import 'package:notes/firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        //returning a home page view
        home: const Homepage(),
        // named navigation routes
        routes: {
          '/login': (context) => const LoginView(),
          '/register': (context) => const Registerview(),
          '/verifyEmail': (context) => const EmailVerifyView(),
          '/notes': (context) => const NotesView(),
        }),
  );
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // build a widget after initializing a fire base connection
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            User? user = FirebaseAuth.instance.currentUser;
            user?.reload();
            if (user != null) {
              if (user.emailVerified) {
                // user is verified and logged in return the notes page
                return const NotesView();
              } else {
                //if a user is registered but not logged in
                //return a login view
                return const LoginView();
              }
            } else {
              // if the user is null or not registered yet
              // return a register view
              return const Registerview();
            }

          default:
            return const Text('Loading');
        }
      },
    );
  }
}
