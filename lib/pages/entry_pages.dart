import 'package:bootcamp_grup4/utils/const.dart';
import 'package:flutter/material.dart';

class EntryPage extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl;

  const EntryPage({
    Key? key,
    required this.title,
    required this.description,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:bacgroundColor,
      appBar: AppBar(
        elevation: 1,
        toolbarHeight: 40,
        centerTitle: true,
        backgroundColor:bacgroundColor,
        title: Text(title,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl != null)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/placeholder.png', // Yer tutucu resim
                      image: imageUrl!,
                      height: 230,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Center(child: Icon(Icons.error, size: 50, color: Colors.red));
                      },
                    ),
                  ),
                ),
              SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              SizedBox(height: 20),
              Text(
                "   $description",
                style: TextStyle(fontSize: 18, height:2,fontStyle: FontStyle.italic,fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
