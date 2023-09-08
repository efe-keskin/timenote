import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;
class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('Please verify your E-mail'),
      TextButton(
          onPressed: () {
            final user = FirebaseAuth.instance.currentUser;
            user?.sendEmailVerification();
          },
          child: Text("Send E-mail Verification"))
    ]);
  }
}
