import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/auth/email_login.dart';
import 'package:flutter_task/screens/home.dart';
import 'package:flutter_task/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EmailRegister extends StatefulWidget {
  const EmailRegister({super.key});

  @override
  State<EmailRegister> createState() => _EmailRegisterState();
}

class _EmailRegisterState extends State<EmailRegister> {

  final _auth = FirebaseAuth.instance;

  //form key
  final _formkey = GlobalKey<FormState>();

  //editing controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //first name field
    final firstName = TextFormField(
        controller: firstNameController,
        autofocus: false,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          fillColor: const Color(0xffFFFFFF), filled: true,
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "First Name",
          hintStyle: const TextStyle(
              fontFamily: "Poppins",
              color: Colors.black45, fontSize: 16
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: Colors.indigo)
          ),
        ),
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if(value!.isEmpty){
            return("First Name can't be empty");
          }
          if(!regex.hasMatch(value)){
            return("Please enter a valid Name (min 3 char)");
          }
          return null;
        },
        onSaved: (value)
        {
          firstNameController.text = value!;
        },
        textInputAction: TextInputAction.next
    ); //FIRST NAME

    //second name field
    final secondName = TextFormField(
        controller: secondNameController,
        autofocus: false,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          fillColor: const Color(0xffFFFFFF), filled: true,
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Last Name",
          hintStyle: const TextStyle(
              fontFamily: "Poppins",
              color: Colors.black45, fontSize: 16
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: Colors.indigo)
          ),
        ),
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if(value!.isEmpty){
            return("Second name can't be empty");
          }
        },
        onSaved: (value)
        {
          secondNameController.text = value!;
        },
        textInputAction: TextInputAction.next
    ); //SECOND NAME

    //email field
    final emailField = TextFormField(
        controller: emailController,
        autofocus: false,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          fillColor: const Color(0xffFFFFFF), filled: true,
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email ID",
          hintStyle: const TextStyle(
              fontFamily: "Poppins",
              color: Colors.black45, fontSize: 16
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: Colors.indigo)
          ),
        ),
        validator: (value) {
          if(value!.isEmpty){
            return ("Please enter your Email");
          }
          //reg expression for email validation
          if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+[a-z]").hasMatch(value)){
            return ("Please enter a valid Email");
          }
          return null;
        },
        onSaved: (value)
        {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next
    ); //EMAIL ID

    //password field
    final passwordField = TextFormField(
        controller: passwordController,
        obscureText: true,
        autofocus: false,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          fillColor: const Color(0xffFFFFFF), filled: true,
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          hintStyle: const TextStyle(
              fontFamily: "Poppins",
              color: Colors.black45, fontSize: 16
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: Colors.indigo)
          ),
        ),
        validator: (value) {
          RegExp regex = RegExp(r'^.{6,}$');
          if(value!.isEmpty){
            return("Please enter your password");
          }
          if(!regex.hasMatch(value)){
            return("Please enter a valid password (min 6 char)");
          }
        },
        onSaved: (value)
        {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done
    );//PASSWORD

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                firstName,
                const SizedBox(height: 25),
                secondName,
                const SizedBox(height: 25),
                emailField,
                const SizedBox(height: 25),
                passwordField,
                const SizedBox(height: 40),
                MaterialButton(
                    elevation: 0, color: yellow,
                    onPressed: () {
                      signUp(emailController.text, passwordController.text);
                    },
                    child:Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 60),
                    child: customText("Register", 18.0, black, FontWeight.bold),
                  )
                ),//REGISTER BUTTON
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Sign Up Function
 void signUp(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        postDetailsToFirestore();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }).catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }
postDetailsToFirestore() async {
    // calling our fire store
    //calling user model
    //sending these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();
userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameController.text;
    userModel.secondName = secondNameController.text;

    await firebaseFirestore
        .collection("email_users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account Created Successfully");

    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}
class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;

  UserModel({this.uid, this.email, this.firstName, this.secondName});

  //receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
    );
  }
//sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
    };
  }
}