import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user=FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ana Sayfa"),
      ),
      body: Center(
        child:Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("giriş yapılan hesap: ${user.email}"),
            MaterialButton(onPressed:(){
              FirebaseAuth.instance.signOut();
            },
            color: Colors.red,
            child: Text("Çıkış Yap"),
            ),
          ],
        ),
      ),
    );
  }
}