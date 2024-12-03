// ignore: file_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/Auth/auth_services.dart';

class EmailVerifyView extends StatefulWidget {
  const EmailVerifyView({super.key});

  @override
  State<EmailVerifyView> createState() => _EmailVerifyViewState();
}

class _EmailVerifyViewState extends State<EmailVerifyView> {
  @override
  void initState() {
    super.initState();
    checkEmailVerification(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Email'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Email Verification Is Sent to Your Email'),
            //  a button to send email vertification link
            TextButton(
                onPressed: () async {
                  try {
                    AuthService.firebase().sendVertificationEmail();
                    // ignore: empty_catches
                  } catch (e) {}
                  Fluttertoast.showToast(
                    msg: 'Vertification Email sent to your email',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                  );
                },
                child: const Text('Resed Verification Email'))
          ],
        ),
      ),
    );
  }
}

Future<void> checkEmailVerification(BuildContext context) async {
  final currrentUser = AuthService.firebase().currentUser;
  if (currrentUser == null) return;
  if (currrentUser.isEmailVerified) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
      (route) => false,
    );
  }
}
