import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

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
        title: const Text("Register"),
        backgroundColor: Colors.pink,
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                      controller: _email,
                      autocorrect: false,
                      enableSuggestions: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: "Enter your email here")),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: const InputDecoration(
                        hintText: "Enter your password here"),
                  ),
                  TextButton(
                    onPressed: () async {
                      try {final email = _email.text;
                      final password = _password.text;
                      final userCredential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                          email: email, password: password);
                      print(userCredential);
                      } on FirebaseAuthException catch (e) {print(e.code); if (e.code =='email-already-in-use'){print("Email is already in use");}else if (e.code =='weak-password'){print("The password is too weak");}else if (e.code == 'invalid email'){print('Invalid email');}}},
                    child: const Text("Register"),
                  ),
                ],
              );
            default:
              return const Text("Loading");
          }
        },
      ),
    );
  }
}