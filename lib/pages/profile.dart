import 'package:book_store/models/bottomNavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            const Center(
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/user.jpeg'),
                radius: 40,
              ),
            ),
            const Divider(
              height: 40,
              color: Color.fromRGBO(66, 66, 66, 1),
            ),
            const Text(
              'Name',
              style: TextStyle(color: Colors.grey, letterSpacing: 2),
            ),
            const SizedBox(height: 10),
            Text(
              'Filbert Ayo',
              style: TextStyle(
                  color: Colors.amberAccent[200],
                  letterSpacing: 2,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const Text(
              'Books Read',
              style: TextStyle(color: Colors.grey, letterSpacing: 2),
            ),
            const SizedBox(height: 10),
            Text(
              '8',
              style: TextStyle(
                  color: Colors.amberAccent[200],
                  letterSpacing: 2,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const Text(
              'Statistics',
              style: TextStyle(color: Colors.grey, letterSpacing: 2),
            ),
            const SizedBox(height: 10),
            // Add more statistics here as needed
            Row(
              children: <Widget>[
                Icon(
                  Icons.star,
                  color: Colors.grey[400],
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Favorite Genre: Mystery',
                  style: TextStyle(
                      color: Colors.grey[400], fontSize: 18, letterSpacing: 1),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Icon(
                  Icons.language,
                  color: Colors.grey[400],
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Languages Read: English, French',
                  style: TextStyle(
                      color: Colors.grey[400], fontSize: 18, letterSpacing: 1),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: <Widget>[
                Icon(
                  Icons.email,
                  color: Colors.grey[400],
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'filbertayo@gmail.com',
                  style: TextStyle(
                      color: Colors.grey[400], fontSize: 18, letterSpacing: 1),
                ),
              ],
            ),
          ],
        ),
      ),
       bottomNavigationBar: const BottomNavigation(),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.grey[900],
      title: const Text(
        'Books Mate',
        style: TextStyle(
          color: Color(0xFFFF6500),
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        GestureDetector(
          child: InkWell(
            child: Container(
              margin: const EdgeInsets.all(10),
              width: 37,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                'assets/icons/search-svgrepo-com.svg',
                height: 18,
                width: 18,
                color: const Color(0xEEEEEEEE),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
