import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/screens/auth_tab.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // check for web platform
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDOloZU4jjvtZQsuxsh-7zu5Y3cpVYPAJg",
          appId: "1:162735991962:web:526b5c54122f9441be8323",
          messagingSenderId: "162735991962",
          projectId: "apeiron-1a2e3",
          storageBucket: "apeiron-1a2e3.appspot.com"),
    );
  }
  // check for android platform
  else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Task',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const AuthTab(),
    );
  }
}
