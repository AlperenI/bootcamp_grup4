// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailcontroller=TextEditingController();
  final _passwordcontroller=TextEditingController();

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }
  Future signUp() async{
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailcontroller.text.trim(), password:_passwordcontroller.text.trim());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Üyelik Sayfası"),
        backgroundColor: Colors.grey.shade300,
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center,
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
              controller:_emailcontroller,
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
              signUp();
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
                    "Üye OL!",
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
          
        ],
      ),
    );
  }
}