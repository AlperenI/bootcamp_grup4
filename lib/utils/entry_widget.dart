import 'package:bootcamp_grup4/pages/entry_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Entry extends StatefulWidget {
  final String title;
  final String description;
  final String? imageUrl; // imageUrl olarak güncelledik

  const Entry({
    Key? key,
    required this.title,
    required this.description,
    this.imageUrl, // imageUrl olarak güncelledik
  }) : super(key: key);

  @override
  State<Entry> createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('favorites')
            .doc(widget.title)
            .get();
        if (mounted) {
          setState(() {
            isFavorite = doc.exists;
          });
        }
      } catch (e) {
        print("Error checking favorite status: $e");
      }
    }
  }

  Future<void> _toggleFavorite() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final entryRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(widget.title);

      try {
        if (isFavorite) {
          await entryRef.delete();
        } else {
          await entryRef.set({
            'title': widget.title,
            'description': widget.description,
            'image_url': widget.imageUrl,
          });
        }

        if (mounted) {
          setState(() {
            isFavorite = !isFavorite;
          });
        }
      } catch (e) {
        print("Error toggling favorite status: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(width: 2, color: Colors.blueGrey),
      ),
      color: Colors.white,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 200,
          minHeight: 120,
        ),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EntryPage(
                  title: widget.title,
                  description: widget.description,
                  imageUrl: widget.imageUrl,
                ),
              ),
            );
          },
          contentPadding: EdgeInsets.only(left: 25, right: 35, top: 20),
          leading: widget.imageUrl == null
              ? null
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.imageUrl!,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
          title: Text(
            widget.title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          subtitle: Text(
            widget.description,
            maxLines: 4,
          ),
          trailing: IconButton(
            selectedIcon: Icon(Icons.favorite, color: Colors.red),
            isSelected: isFavorite,
            onPressed: _toggleFavorite,
            color: Colors.black,
            padding: EdgeInsets.all(0),
            iconSize: 25,
            splashRadius: 1,
            icon: Icon(Icons.favorite_outline, color: Colors.red),
          ),
          dense: true,
        ),
      ),
    );
  }
}
