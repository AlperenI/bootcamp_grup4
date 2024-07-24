import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bootcamp_grup4/utils/entry_widget.dart'; 
import 'package:bootcamp_grup4/utils/const.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot> _entries = [];
  List<QueryDocumentSnapshot> _filteredEntries = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterEntries);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterEntries);
    _searchController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: bacgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        toolbarHeight: 40,
        centerTitle: true,
        title: Text('Favorilerim', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: bacgroundColor,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
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

                _entries = snapshot.data!.docs;
                _filteredEntries = _filteredEntries.isNotEmpty ? _filteredEntries : _entries;

                return ListView.builder(
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
                );
              },
            ),
    );
  }
}
