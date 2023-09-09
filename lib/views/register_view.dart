import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:notetime/constants/routes.dart';
import 'package:notetime/services/auth/auth_service.dart';
import 'package:notetime/utilities/show_error_dialog.dart';

import '../services/auth/auth_exceptions.dart';

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
                final userCredential = await AuthService.firebase().createUser(
                        email: email, password: password);
                AuthService.firebase().sendEmailVerification();
                await Navigator.of(context)
                    .pushNamedAndRemoveUntil(verifyRoute, (route) => false);
                devtools.log(userCredential.toString());
              }
              on EmailAlreadyInUseAuthException {
                await showErrorDialog(context, "Email is already in use");
              }
              on WeakPasswordAuthException {
                await showErrorDialog(context, "Password is weak");
              }
              on InvalidEmailAuthException {
                await showErrorDialog(context, "Email is already in use");
              }
              on GenericAuthException {
                await showErrorDialog(context, "Failed to register");
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
