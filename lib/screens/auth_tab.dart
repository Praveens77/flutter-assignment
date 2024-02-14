import 'package:flutter/material.dart';
import 'package:flutter_task/auth/email_login.dart';
import 'package:flutter_task/auth/email_register.dart';
import 'package:flutter_task/utils.dart';

class AuthTab extends StatelessWidget {
  const AuthTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: customText("Login to Dashboard account", 20.0, black, FontWeight.bold),
          bottom: const TabBar(
            unselectedLabelColor: grey,
            labelStyle: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500
            ),
            tabs: [
              Tab(text: "Login"),
              Tab(text: "Register"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            EmailLogIn(),
            EmailRegister(),
          ],
        ),
      ),
    );
  }
}
