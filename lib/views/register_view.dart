
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                appBar: AppBar(title: Text("Register"),backgroundColor: Colors.deepPurpleAccent,),
                body: Column(
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
                    ),TextButton(onPressed: () {Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);}, child: Text("Already have an account?  Login Here!"))
                  ],
                ),
              );
  }
}