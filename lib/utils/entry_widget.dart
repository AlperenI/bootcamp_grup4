import 'package:bootcamp_grup4/pages/entry_pages.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class Entry extends StatefulWidget {
  final String title;
  final String description;
  final File? imageFile;

  const Entry({Key? key, required this.title, required this.description, this.imageFile}) : super(key: key);

  @override
  State<Entry> createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  bool selected = false;

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
                  imageFile: widget.imageFile,
                ),
              ),
            );
          },
          contentPadding: EdgeInsets.only(left: 25, right: 35, top: 5),
          leading: widget.imageFile == null
              ? null
              : ClipOval(
                  child: Image.file(
                    widget.imageFile!,
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
            isSelected: selected,
            onPressed: () {
              setState(() {
                selected = !selected;
              });
            },
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