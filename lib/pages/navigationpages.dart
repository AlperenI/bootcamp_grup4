// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:bootcamp_grup4/utils/const.dart';
import 'package:bootcamp_grup4/utils/page_list.dart';

import 'package:flutter/material.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
    int currentindex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: pages[currentindex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1,
        backgroundColor: bacgroundColor,
        selectedItemColor: Colors.brown,
        showUnselectedLabels: false,
        onTap: (value) {
          setState(() {
            currentindex=value;
            pages[currentindex];
          });
        },
        currentIndex: currentindex,
        items: [
          BottomNavigationBarItem(label: "Home",icon:Icon(Icons.home_outlined)),
          BottomNavigationBarItem(label: "Favorite",icon:Icon(Icons.favorite_rounded)),
          BottomNavigationBarItem(label: "Settings",icon:Icon(Icons.settings)),
          ],
        ),
    );
  }
}

