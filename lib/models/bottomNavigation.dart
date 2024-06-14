import 'package:book_store/pages/home.dart';
import 'package:book_store/pages/myBooks.dart';
import 'package:book_store/pages/profile.dart';
import 'package:book_store/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  

  List<Widget> _pages = [
    HomePage(),    // Assuming these widgets have appropriate non-const constructors
     SearchPage(),
     MyBooks(),
    ProfilePage(),
  ];

  bool _isLoading = false;

  void _onItemTapped(int index) async {
    setState(() {
      _isLoading = true; // Show loader when card is tapped
    });
    await Future.delayed(
        const Duration(seconds: 1)); // Simulate loading for 2 seconds
    setState(() {
      _selectedIndex = index;
      _isLoading = false;
    });
// Navigate to the corresponding page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          // Otherwise, navigate to the selected page
          return _pages[index];
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          if (_isLoading)
            Container(
              color: const Color(0xff2b4260).withOpacity(0.7),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ),
            ),
          Container(
            color: const Color(0xff323232),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GNav(
                backgroundColor: const Color(0xff323232),
                color: const Color(0xFFECECEC),
                activeColor: const Color(0xFFFF6500),
                tabBackgroundColor: const Color.fromRGBO(66, 66, 66, 1),
                gap: 8,
                onTabChange: _onItemTapped,
                iconSize: 24,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: 'Shopping',
                  ),
                  GButton(
                    icon: Icons.search,
                    text: 'Search',
                  ),
                  GButton(
                    icon: Icons.book,
                    text: 'My Book',
                  ),
                  GButton(
                    icon: Icons.account_circle,
                    text: 'Account',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
