import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerifyView extends StatefulWidget {
  const EmailVerifyView({super.key});

  @override
  State<EmailVerifyView> createState() => _EmailVerifyViewState();
}

class _EmailVerifyViewState extends State<EmailVerifyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:const Text('Verify Your Email') ,
      ) ,
      body: Center(
        child: Column(
          children: [
            const Text('Verify your email to Continue'),
            TextButton(
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
              },
              child: const Text('send verification email'),
            )
          ],
        ),
      ),
    );
  }
}
