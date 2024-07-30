import 'dart:convert';

import 'package:book_store/API/api.dart';
import 'package:book_store/API/ui.dart';



import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MyBooks extends StatefulWidget {
  const MyBooks({Key? key});

  @override
  State<MyBooks> createState() => _MyBooksState();
}

class _MyBooksState extends State<MyBooks> {
  List<dynamic> book = [];

  String? name;
  String? email;
  String? token;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    fetchCartData();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      email = prefs.getString('email');
      token = prefs.getString('api_token');
    });
  }

  Future<void> fetchCartData() async {
    // Call your API to fetch cart items
    final result = await Api().getMyCart(route: '/getMyCart');
    final response = json.decode(result.body);

    if (response['status']) {
      setState(() {
        book = response['data'];
      });
    } else {
      throw Exception('Failed to load cart items');
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUi screenUi = ScreenUi(context);
    return Scaffold(
      appBar: _appBar(),
      body: token == null || token!.isEmpty || book.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    size: screenUi.scaleWidth(50.0),
                    color: Colors.white,
                  ),
                  SizedBox(height: screenUi.scaleWidth(5.0)),
                  Text(
                    "Your book list is empty",
                    style: TextStyle(
                        fontSize: screenUi.scaleWidth(12.0),
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ],
              ),
            )
          : Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: screenUi.scaleWidth(8.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    'My Books',
                    style: TextStyle(
                      color: Color(0xEEEEEEEE),
                      fontSize: screenUi.scaleWidth(18.0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenUi.scaleWidth(5.0)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: book.length,
                      itemBuilder: (context, index) {
                        // final product = productData[index];
                        return Card(
                          color: const Color(0xff323232),
                          elevation: 3,
                          child: ListTile(
                            leading: Image.network(
                              '${book[index]['thumbnailUrl']}',
                              fit: BoxFit.cover,

                            ),
                            title: Text(
                              book[index]['title'],
                              style:  TextStyle(color: Colors.white,     fontSize: screenUi.scaleWidth(10.0),),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book[index]['authors'],
                                  style:  TextStyle(color: Colors.white,     fontSize: screenUi.scaleWidth(10.0),),
                                ),
                                Text(
                                  book[index]['publishedDate'],
                                  style: TextStyle(color: Colors.white,     fontSize: screenUi.scaleWidth(10.0),),
                                ),
                           
                              ],
                            ),
                            trailing: IconButton(
                                icon: const Icon(
                                  Icons.note_add,
                                  color: Colors.red,
                                ),
                                onPressed: () {}
                                //  => deleteProduct(index),
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
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
    );
  }
}
