import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final user = FirebaseAuth.instance.currentUser!;
  File? _image;

  final phoneFormatter = MaskTextInputFormatter(
    mask: '### ### ## ##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordMatched = true;

  get backgroundColor => null;

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        }
      });
    } catch (e) {
      print("Hatalı Fotoğraf: $e");
    }
  }

  void _checkPasswordMatch(String value) {
    setState(() {
      _isPasswordMatched =
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // Bu, varsayılan geri düğmesini kaldırır.
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Center(
                child: Text('Ayarlar'),
              ),
            ),
            SizedBox(width: 48), // Sağ tarafta boşluk bırakmak için
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? Icon(
                            Icons.add_a_photo,
                            size: 60,
                            color: Colors.grey[700],
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "${user.email}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              _buildTextField(
                label: 'Şifre',
                isPassword: true,
                controller: _passwordController,
                onChanged: _checkPasswordMatch,
                borderColor: _isPasswordMatched ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                label: 'Şifre Doğrulama',
                isPassword: true,
                controller: _confirmPasswordController,
                onChanged: _checkPasswordMatch,
                borderColor: _isPasswordMatched ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                label: 'Telefon',
                keyboardType: TextInputType.number,
                inputFormatters: [phoneFormatter],
              ),
              const SizedBox(height: 70),
              ElevatedButton(
                onPressed: () {
                  // Kaydet
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 184, 187, 189),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Ayarları Kaydet',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 184, 187, 189),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Çıkış Yap",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? initialValue,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    TextEditingController? controller,
    Function(String)? onChanged,
    Color borderColor = Colors.grey,
  }) {
    return TextField(
      obscureText: isPassword,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: borderColor, width: 2.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: borderColor, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: borderColor, width: 2.0),
        ),
      ),
    );
  }
}
