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
      backgroundColor: Color.fromRGBO(20, 33, 61, 1),
      appBar: AppBar(
        elevation: 1,
        toolbarHeight: 40,
        centerTitle: true,
        backgroundColor: Color.fromRGBO(20, 33, 61, 1),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(252, 163, 17, 1),
            fontSize: 20,
          ),
        ),
        iconTheme: IconThemeData(color: Color.fromRGBO(202, 139, 38, 1)),
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
                    borderRadius: BorderRadius.circular(15),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/placeholder.png', // Yer tutucu resim
                      image: imageUrl!,
                      height: 230,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.error,
                            size: 50,
                            color: Colors.red,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(20, 33, 61, 1),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Text(
                  textAlign: TextAlign.center,
                  "  $description",
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.3,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(252, 163, 17, 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
