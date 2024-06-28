// ignore_for_file: prefer_const_constructors

import 'package:bootcamp_grup4/firebase/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailcontroller=TextEditingController();
  final _passwordcontroller=TextEditingController();
  Future signIn() async{
    if (_emailcontroller.text.isNotEmpty && _passwordcontroller.text.isNotEmpty) {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailcontroller.text.trim(), password: _passwordcontroller.text.trim()); 
    }
    
  }
  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Giriş Sayfası"),
        backgroundColor: Colors.grey.shade300,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child:Padding(padding: EdgeInsets.only(left: 20),
                  child: TextField(
                    controller: _emailcontroller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "email",
                    ),
                  ),
                  ),
                ),
                ),
                SizedBox(height: 10,),
                Padding(padding: EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child:Padding(padding: EdgeInsets.only(left: 20),
                  child: TextField(
                    controller: _passwordcontroller,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "şifre",
                    ),
                  ),
                  ),
                ),
                ),
                SizedBox(height: 10,),
                GestureDetector(onTap: (){
                  setState(() {
                    signIn();
                  });
                },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(color:Colors.brown,
                      borderRadius: BorderRadius.circular(12)
                      ),
                      child: Center(
                        child: Text(
                          "Giriş Yap",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight:FontWeight.bold,
                            color: Colors.white),
                            ),
                      ),
                          ),
                  ),
                ),
                SizedBox(height: 15,),
                Row(mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    Text("Üye Değil misin?",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder:(context) => RegisterPage(),),);
                      },
                      child: Text(
                        " Üye Ol",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                          ),
                          ),
                  ],
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}