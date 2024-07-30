import 'package:book_store/pages/home.dart';
import 'package:book_store/pages/myBooks.dart';
import 'package:book_store/pages/profile.dart';
import 'package:book_store/pages/search.dart';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    HomePage(),
    SearchPage(),
    MyBooks(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        color: Color(0xff323232),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: GNav(
            backgroundColor: Color(0xff323232),
            color: Color(0xFFEEEEEE),
            activeColor: Color(0xFFFF6500),
            tabBackgroundColor: Color.fromRGBO(66, 66, 66, 1),
            gap: 8,
            onTabChange: _onItemTapped,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
              ),
              GButton(
                icon: Icons.book,
                text: 'My books',
              ),
              GButton(
                icon: Icons.account_circle,
                text: 'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
