import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
          TextButton(
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                try{
                 await user?.sendEmailVerification();
                // ignore: empty_catches
                }catch(e) {}
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
