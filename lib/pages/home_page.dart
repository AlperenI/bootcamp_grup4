// ignore_for_file: prefer_const_constructors
import 'dart:io';
import 'package:bootcamp_grup4/utils/const.dart';
import 'package:bootcamp_grup4/utils/entry_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    final ImagePicker _picker = ImagePicker();
  File? _image;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool _titleError = false;
  bool _descriptionError = false;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Image picker error: $e");
    }
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Başlık ve Yazı Girin'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _image == null
                        ? Text('Resim seçilmedi.')
                        : Image.file(_image!),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Fotoğraf Seç'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Başlık',
                        border: OutlineInputBorder(),
                        errorText: _titleError ? 'Başlık gerekli' : null,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Yazı',
                        border: OutlineInputBorder(),
                        errorText: _descriptionError ? 'Yazı gerekli' : null,
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Kapat'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Kaydet'),
                  onPressed: () async {
                    setState(() {
                      _titleError = _titleController.text.isEmpty;
                      _descriptionError = _descriptionController.text.isEmpty;
                    });

                    if (!_titleError && !_descriptionError) {
                      // Firestore'a veri ekleme
                      await FirebaseFirestore.instance.collection('entries').add({
                        'title': _titleController.text,
                        'description': _descriptionController.text,
                        'image_url': _image != null
                          ? await _uploadImageToStorage(_image!) // Resim yükleme
                          : null,
                      });

                      setState(() {
                        _titleController.clear();
                        _descriptionController.clear();
                        _image = null;
                      });
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
Future<String?> _uploadImageToStorage(File imageFile) async {
  try {
    final storageRef = FirebaseStorage.instance.ref().child('images/${DateTime.now().toIso8601String()}');
    final uploadTask = storageRef.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() => {});
    final imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  } catch (e) {
    print("Image upload error: $e");
    return null;
  }
}
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        toolbarHeight: 40,
        centerTitle: true,
        backgroundColor:bacgroundColor,
        title: Text("Ana Sayfa",style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      backgroundColor: bacgroundColor,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('entries').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Veri bulunamadı.'));
          }

          final entries = snapshot.data!.docs;

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index].data() as Map<String, dynamic>;
              final title = entry['title'] ?? '';
              final description = entry['description'] ?? '';
              final imageUrl = entry['image_url'] as String?;

              return Entry(
                title: title,
                description: description,
                imageFile: imageUrl != null ? File(imageUrl) : null,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAlertDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
