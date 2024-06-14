import 'dart:convert';
import 'dart:math';

import 'package:book_store/models/bookModel.dart';
import 'package:book_store/models/bottomNavigation.dart';
import 'package:book_store/pages/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'search.dart';
import 'package:http/http.dart' as http;

const String apiKey = 'AIzaSyBvaguFsbt-tVR7qrrTXOTtZpKaqiaijZc';

class HomePage extends StatefulWidget {
  const HomePage({super.key });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  Map<String, List<Book>> booksByCategory = {};
  bool isLoading = false;
  final Random random = Random();

  @override
  bool get wantKeepAlive => true; // Ensure the state is kept alive

  @override
  void initState() {
    super.initState();
    if (booksByCategory.isEmpty) {
      fetchData();
    }
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final categories = [
        'Thriller', 'Horror',
         'History', 'Fiction', 'Comics & Graphic Novels',
        'Art', 'Religion', 'Philosophy', 'Action and Adventure', 'Poetry',
        'Biography', 'Young Adult Fiction', 'Romance', 'Mystery', 'Fantasy',
        'Science',
         'Childrens Fiction',
          'Technology', 'Crime Fiction', 'Education',
      ];
      final Map<String, List<Book>> booksByCategory = {};

      for (String category in categories) {
        final response = await http.get(Uri.parse(
            'https://www.googleapis.com/books/v1/volumes?q=$category&key=$apiKey&startIndex=${random.nextInt(10)}'));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final List<dynamic> items = data['items'] ?? [];
          booksByCategory[category] =
              items.map((item) => Book.fromJson(item)).toList();
          booksByCategory[category]!.shuffle(); // Shuffle the books list
        } else {
          throw Exception('Failed to load book details');
        }
      }

      setState(() {
        this.booksByCategory = booksByCategory;
      });
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // This ensures the mixin is properly integrated

    return Scaffold(
      appBar: appBar(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Color(0xFFFF6500)),
              ),
            )
          : ListView(
              children: booksByCategory.entries.map((entry) {
                String category = entry.key;
                List<Book> books = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: Text(
                        category,
                        style: const TextStyle(
                          color: Color(0xEEEEEEEE),
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      height: 260,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BookDetails(book: books[index]),
                                ),
                              );
                            },
                            child: Container(
                              width: 150,
                              decoration: BoxDecoration(
                                color: const Color(0xff323232),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        width: 140,
                                        height: 170,
                                        margin: const EdgeInsets.only(top: 5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(3, 3),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            books[index].thumbnailUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, left: 10, right: 10),
                                        child: Center(
                                          child: Text(
                                            books[index].title,
                                            style: const TextStyle(
                                              color: Color(0xEEEEEEEE),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    bottom: 5,
                                    left: 10,
                                    child: Text(
                                      'Year: ${books[index].publishedDate}',
                                      style: const TextStyle(
                                        color: Color(0xFFFF6500),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 5,
                                    right: 10,
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          books[index].ratingsCount.toString(),
                                          style: const TextStyle(
                                            color: Color(0xEEEEEEEE),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          width: 10,
                        ),
                        itemCount: books.length,
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                );
              }).toList(),
            ),
              bottomNavigationBar: const BottomNavigation(),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.grey[900],
      title: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Books mate',
            style: TextStyle(
              color: Color(0xFFFF6500),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        GestureDetector(
          child: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SearchPage()));
            },
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


//issue on navigation bar