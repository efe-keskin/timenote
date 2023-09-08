import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notetime/constants/routes.dart';
import 'package:notetime/views/register_view.dart';
import 'dart:developer' as devtools show log;
import 'package:notetime/utilities/show_error_dialog.dart';
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
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.pink,
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
              final email = _email.text;
              final password = _password.text;
              try {
                final userCredential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(notesRoute, (route) => false);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  showErrorDialog(context, "Account not found");
                } else if (e.code == 'wrong-password') {
                  showErrorDialog(context, "Wrong credentials");
                } else if (e.code == 'too-many-requests') {
                  showErrorDialog(context, "Too many wrong attempts");
                } else if (e.code == 'user-disabled') {
                  showErrorDialog(context, "This account is disabled");
                } else if (e.code == 'channel-error') {
                  showErrorDialog(context, "Email and Password cant be empty");
                } else {
                  devtools.log(e.code);
                  await showErrorDialog(context, "Error: ${e.code}");
                }
              }catch (e) {
                showErrorDialog(context, e.toString());

              }
            },
            child: const Text("Login"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: Text("Not registered yet? Register here!"))
        ],
      ),
    );
  }
}

