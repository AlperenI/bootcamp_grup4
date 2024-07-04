// ignore_for_file: prefer_const_constructors
import 'package:bootcamp_grup4/utils/const.dart';
import 'package:bootcamp_grup4/utils/entry_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        toolbarHeight: 40,
        centerTitle: true,
        backgroundColor:bacgroundColor,
        title: Text("Ana Sayfa",style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      backgroundColor: bacgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Entry(),
              Entry(),
              Entry(),
              Entry(),
              Entry(),
              Entry(),
              Entry(),
              
            ],
          ),
        ),
      ),
    );
  }
}
