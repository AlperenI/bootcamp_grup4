import 'package:bootcamp_grup4/pages/navigationpages.dart';
import 'package:bootcamp_grup4/firebase/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return NavigationPage();
          }else{
            return LoginPage();
          }
        },
      ),
    );
  }
}