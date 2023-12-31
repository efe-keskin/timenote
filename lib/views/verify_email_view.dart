import 'package:flutter/material.dart';
import 'package:notetime/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log;
import 'package:notetime/utilities/show_logout_dialog.dart';
import '../constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

enum MenuAction { logout }

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify E-mail"),
        backgroundColor: Colors.teal,
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        registerRoute, (route) => false);
                  }
                  devtools.log(shouldLogout.toString());
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text("Log Out"))
              ];
            },
          )
        ],
      ),
      body: Column(children: [
        Text(
            "We've sent you a verification email, please check out your mailbox."),
        TextButton(
            onPressed: () {
              AuthService.firebase().sendEmailVerification();
            },
            child: Text("Send a new verification email")),
        TextButton(
            onPressed: () {
              AuthService.firebase().logOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: Text("Reset"))
      ]),
    );
  }
}
