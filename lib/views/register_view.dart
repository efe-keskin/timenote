import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

import 'package:notetime/constants/routes.dart';
import 'package:notetime/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
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
        title: Text("Register"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Column(
        children: [
          TextField(
              controller: _email,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.emailAddress,
              decoration:
                  const InputDecoration(hintText: "Enter your email here")),
          TextField(
            controller: _password,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            decoration:
                const InputDecoration(hintText: "Enter your password here"),
          ),
          TextButton(
            onPressed: () async {
              try {
                final email = _email.text;
                final password = _password.text;
                final userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: password);
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                await Navigator.of(context)
                    .pushNamedAndRemoveUntil(verifyRoute, (route) => false);
                devtools.log(userCredential.toString());
              } on FirebaseAuthException catch (e) {
                devtools.log(e.code);
                if (e.code == 'email-already-in-use') {
                  await showErrorDialog(context, "Email is already in use");
                } else if (e.code == 'weak-password') {
                  await showErrorDialog(context, "This password is too weak");
                } else if (e.code == 'invalid-email') {
                  await showErrorDialog(context, "Please enter a valid email");
                } else {
                  await showErrorDialog(context, "${e.code}");
                }
              } catch (e) {
                await showErrorDialog(context, "${e.toString()}");
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: Text("Already have an account?  Login Here!"))
        ],
      ),
    );
  }
}
