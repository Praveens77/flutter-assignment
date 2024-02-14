import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/auth/email_login.dart';
import 'package:flutter_task/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatefulWidget {
 const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  //form key
  final _formkey = GlobalKey<FormState>();

  //editing controller
  final TextEditingController emailController = TextEditingController();

  //firebase
  final _auth = FirebaseAuth.instance;

  void _submit() {
    final isValid = _formkey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    else {
      if(_formkey.currentState!.validate()){
      }
      _auth.sendPasswordResetEmail(email: emailController.text)
          .then((value) => {
            Fluttertoast.showToast(msg: "Password reset link sent successfully to your email"),
          }).catchError((e){
          Fluttertoast.showToast(msg: e!.message);
        });
      }
    _formkey.currentState?.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Align(
                  alignment: Alignment.topLeft,
                  child: customText("Forgot your password ?", 20.0, black, FontWeight.bold),),
              Align(
                  alignment: Alignment.topLeft,
                  child: customText("Enter your email here to get the password reset link", 16.0, lightBlack, FontWeight.bold),
                      ),
              const SizedBox(height: 30),
              TextFormField(
                controller: emailController,
                autofocus: false,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ("Please enter your Email");
                  }
                  //reg expression for email validation
                  if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+[a-z]")
                      .hasMatch(value)) {
                    return ("Please enter a valid Email");
                  }
                  return null;
                },
                onSaved: (value) {
                  emailController.text = value!;
                },
                decoration: InputDecoration(
                  fillColor: const Color(0xffFFFFFF),
                  filled: true,
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  hintText: "Email*",
                  hintStyle: const TextStyle(
                      fontFamily: "Poppins", color: Colors.black45, fontSize: 16),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: const BorderSide(color: Colors.indigo)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  customText("Didn't Received mail?", 16.0, lightBlack, FontWeight.bold),
                  GestureDetector(
                    child: customText("  Resend Link", 16.0, black, FontWeight.bold),
                    onTap: () {
                      resendLink();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                      elevation: 0,
                      color: yellow,
                      onPressed: () {
                        _auth.sendPasswordResetEmail(email: emailController.text);
                        _submit();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                        child: customText("Send", 18.0, black, FontWeight.bold)
                      )),
                      MaterialButton(
                  elevation: 0, color: const Color(0xffFFFFFF),
                  shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.indigo)
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                  child: customText("Login", 18.0, black, FontWeight.bold)
                                    )
              ),
              
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // resend password reset link
  void resendLink() async {
    if(_formkey.currentState!.validate()){
      await _auth.sendPasswordResetEmail(email: emailController.text)
          .then((uid) => {
        Fluttertoast.showToast(msg: "Link Resent Successfully"),
      }).catchError((e){
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }
}