import 'dart:async';
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
  TextEditingController _searchController = TextEditingController();
  bool _titleError = false;
  bool _descriptionError = false;
  bool _isLoading = false;
  List<QueryDocumentSnapshot> _entries = [];
  List<QueryDocumentSnapshot> _filteredEntries = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchEntries();
    _timer = Timer.periodic(Duration(seconds: 50), (timer) {
      _fetchEntries();
    });
    _searchController.addListener(_filterEntries);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchController.removeListener(_filterEntries);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchEntries() async {
    final snapshot = await FirebaseFirestore.instance.collection('entries').get();
    setState(() {
      _entries = snapshot.docs;
      _filteredEntries = _entries;
    });
  }

  void _filterEntries() {
    setState(() {
      _filteredEntries = _entries.where((entry) {
        final title = entry['title']?.toLowerCase() ?? '';
        final query = _searchController.text.toLowerCase();
        return title.contains(query);
      }).toList();
    });
  }

  Future<void> _pickImage(StateSetter setDialogState) async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setDialogState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Image picker error: $e");
    }
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
bool _isValidDescription(String description) {
  final validCharacters = description.replaceAll(RegExp(r'\s+'), '');
  return validCharacters.length >= 20;
}

void _showAlertDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: bacgroundColor,
            title: Text('Başlık ve Yazı Girin'),
            content: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _image == null
                        ? Text('Fotoğraf seçilmedi.')
                        : Image.file(_image!, fit: BoxFit.cover, height: 300),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
                      onPressed: () => _pickImage(setDialogState),
                      child: Text('Fotoğraf Seçin', style: TextStyle(color: Colors.black)),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5)),
                        focusColor: Colors.brown,
                        hintText: 'Başlığınız',
                        border: OutlineInputBorder(),
                        errorText: _titleError ? 'Başlık gerekli' : null,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5)),
                        focusColor: Colors.brown,
                        hintText: 'Yazınız (minimum 20 karakter)',
                        border: OutlineInputBorder(),
                        errorText: _descriptionError ? 'Yazı en az 20 karakter olmalı' : null,
                      ),
                      minLines: 10,
                      maxLines: 20,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                child: Text('Kapat', style: TextStyle(color: Colors.brown)),
                onPressed: () {
                  _titleController.clear();
                  _descriptionController.clear();
                  setState(() {
                    _image = null;
                  });
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Kaydet', style: TextStyle(color: Colors.brown)),
                onPressed: _isLoading
                    ? null
                    : () async {
                        setDialogState(() {
                          _titleError = _titleController.text.isEmpty;
                          _descriptionError = !_isValidDescription(_descriptionController.text);
                        });

                        if (!_titleError && !_descriptionError) {
                          setDialogState(() {
                            _isLoading = true;
                          });

                          await FirebaseFirestore.instance.collection('entries').add({
                            'title': _titleController.text,
                            'description': _descriptionController.text,
                            'image_url': _image != null ? await _uploadImageToStorage(_image!) : null,
                          });

                          setState(() {
                            _titleController.clear();
                            _descriptionController.clear();
                            _image = null;
                            _isLoading = false;
                          });
                          _fetchEntries();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        toolbarHeight: 45,
        centerTitle: true,
        backgroundColor: bacgroundColor,
        title: Text("Ana Sayfa", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(55.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: BorderSide(width: 2)),
                focusColor: Colors.brown,
                hintText: 'Arama...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: bacgroundColor,
      body: _filteredEntries.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _filteredEntries.length,
            itemBuilder: (context, index) {
              final entry = _filteredEntries[index].data() as Map<String, dynamic>;
              final title = entry['title'] ?? '';
              final description = entry['description'] ?? '';
              final imageUrl = entry['image_url'] as String?;

              return Entry(
                title: title,
                description: description,
                imageUrl: imageUrl,
              );
            },
          ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        onPressed: _showAlertDialog,
        child: Icon(Icons.create_outlined),
      ),
    );
  }
}
