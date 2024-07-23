import 'package:bootcamp_grup4/utils/const.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class EntryPage extends StatelessWidget {
  final String title;
  final String description;
  final File? imageFile;

  const EntryPage({Key? key, required this.title, required this.description, this.imageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bacgroundColor,
      appBar: AppBar(
        elevation: 1,
        toolbarHeight: 55,
        centerTitle: true,
        backgroundColor:bacgroundColor,
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageFile != null) 
                Center(
                  child: Image.file(imageFile!),
                ),
              SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold,color:Colors.red),
              ),
              SizedBox(height: 20),
              Text(
                description,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
