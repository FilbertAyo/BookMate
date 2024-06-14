import 'package:book_store/models/bottomNavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/action.dart';

class MyBooks extends StatefulWidget {
  const MyBooks({Key? key});

  @override
  State<MyBooks> createState() => _MyBooksState();
}

class _MyBooksState extends State<MyBooks> {
  List<ActionModel> actions = [];

  @override
  void initState() {
    super.initState();
    _getActions();
  }

  void _getActions() {
    setState(() {
      actions = ActionModel.getActions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'My Books',
              style: TextStyle(
                color: Color(0xEEEEEEEE),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: actions.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  return _buildActionCard(actions[index]);
                },
              ),
            ),
          ],
        ),
      ),
       bottomNavigationBar: const BottomNavigation(),
    );
  }

  Widget _buildActionCard(ActionModel action) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff323232),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 120,
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(action.cover),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    action.name,
                    style: const TextStyle(
                      color: Color(0xEEEEEEEE),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    action.year,
                    style: const TextStyle(
                      color: Color(0xEEEEEEEE),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
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
          onTap: () {
            // Navigate to search page
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              // color: const Color(0xEEEEEEEE),
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
      ],
    );
  }
}
