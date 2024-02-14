import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/auth/forgot_password.dart';
import 'package:flutter_task/screens/home.dart';
import 'package:flutter_task/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EmailLogIn extends StatefulWidget {
  const EmailLogIn({Key? key});

  @override
  State<EmailLogIn> createState() => _EmailLogInState();
}

class _EmailLogInState extends State<EmailLogIn> {
  // Form key
  final _formKey = GlobalKey<FormState>();

  // Editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Firebase
  final _auth = FirebaseAuth.instance;

  // Loading state
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    // Email form field
    final emailField = TextFormField(
      controller: emailController,
      autofocus: false,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email*",
        hintStyle: const TextStyle(
            fontFamily: "Poppins", color: Colors.black45, fontSize: 16),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: Colors.indigo)),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter your Email");
        }
        // Reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+[a-z]").hasMatch(value)) {
          return ("Please enter a valid Email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
    ); //EMAIL ID

    // Password field
    final passwordField = TextFormField(
      controller: passwordController,
      autofocus: false,
      obscureText: true,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        fillColor: const Color(0xffFFFFFF),
        filled: true,
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password*",
        hintStyle: const TextStyle(
            fontFamily: "Poppins", color: Colors.black45, fontSize: 16),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: Colors.indigo)),
      ),
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Please enter your password");
        }
        if (!regex.hasMatch(value)) {
          return ("Please enter a valid password (min 6 char)");
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
    ); //PASSWORD

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                emailField,
                const SizedBox(height: 20),
                passwordField,
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _loading
                          ? const SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.indigo),
                              ),
                            ) : MaterialButton(
                      elevation: 0,
                      color: yellow,
                      onPressed: () {
                        _handleLogin();
                      },
                      child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 50),
                              child: customText("Login", 18.0, black,
                                  FontWeight.bold),
                            ),
                    ),
                    GestureDetector(
                      child: customText("Forgot your password*", 14.0, black,
                          FontWeight.bold),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForgotPassword()));
                      },
                    ),
                  ],
                ), //LOG IN BUTTON
                const SizedBox(height: 30),
                Row(
                  children: [
                    customText("or register with", 16.0, lightBlack,
                        FontWeight.w500),
                    const SizedBox(width: 20),
                    customText("Facebook", 16.0, black, FontWeight.w500),
                    const SizedBox(width: 10),
                    customText("Google", 16.0, black, FontWeight.w500),
                    const SizedBox(width: 10),
                    customText("LinkedIn", 16.0, black, FontWeight.w500),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Login Function
  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true; // Start loading state
      });
      await _auth
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((uid) => {
                Fluttertoast.showToast(msg: "Login Successful"),
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomePage())),
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      }).whenComplete(() {
        setState(() {
          _loading = false; // End loading state
        });
      });
    }
  }
}
