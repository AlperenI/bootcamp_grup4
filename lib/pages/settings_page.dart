import 'package:bootcamp_grup4/utils/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final user=FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bacgroundColor,
      body:Center(
        child:Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Giriş Yapılan hesap ${user.email}"),
            MaterialButton(onPressed:(){
              FirebaseAuth.instance.signOut(); 
            },
            color: Colors.red,
            child: Text("Çıkış Yap"),
            ),
          ],
        )
      ),
    );
  }
}