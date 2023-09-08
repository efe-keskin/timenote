import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notetime/views/register_view.dart';

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
      appBar: AppBar(title: Text("Login"),backgroundColor: Colors.pink,),
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
              final email = _email.text;
              final password = _password.text;
              try {final userCredential = await FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                email: email, password: password,);
              print(userCredential);}
              on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found'){print("The e-mail isn't registered");}
                else if (e.code == 'wrong-password') {print('The password you entered is wrong');}
                else if (e.code =='too-many-requests'){print('You have attemted to many wrong passwords, reset your password to continue');}
                else if (e.code =='user-disabled'){print('This account has been disabled');}
                else if (e.code =='channel-error'){print('email and password cant be blank');}
                else {print(e.code);}
              }



            },
            child: const Text("Login"),
          ),
          TextButton(onPressed: () {Navigator.of(context).pushNamedAndRemoveUntil("/register", (route) => false);}, child: Text("Not registered yet? Register here!"))
        ],
      ),
    );}}