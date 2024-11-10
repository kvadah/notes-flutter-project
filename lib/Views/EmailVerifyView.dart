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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Email'),
      ),
      body: Column(
        children: [
          const Text('verify your email to login'),
          //  a button to send email vertification link
          TextButton(
              onPressed: () async {
                try {
                  //sending an email
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
              child: const Text('Send vertification Email'))
        ],
      ),
    );
  }
}
