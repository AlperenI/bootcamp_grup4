// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bootcamp_grup4/utils/entry_widget.dart'; 
import 'package:bootcamp_grup4/utils/const.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: bacgroundColor,
      appBar: AppBar(
        iconTheme:  IconThemeData(color: Colors.black),
        toolbarHeight: 40,
        centerTitle: true,
        title: Text('Favorilerim',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: bacgroundColor,
      ),
      body: userId == null
          ? Center(child: Text('Giriş yapmanız gerekiyor.'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .collection('favorites')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Henüz burada bir şey yok.'));
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
                      imageUrl: imageUrl, // imageUrl'yi File yerine doğrudan geçiyoruz
                    );
                  },
                );
              },
            ),
    );
  }
}
