import 'dart:convert';
import 'dart:math';

import 'package:book_store/API/ui.dart';
import 'package:book_store/models/bookModel.dart';
import 'package:book_store/pages/book.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String apiKey = 'AIzaSyBvaguFsbt-tVR7qrrTXOTtZpKaqiaijZc';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  Map<String, List<Book>> booksByCategory = {};
  Map<String, bool> isCategoryLoading = {};
   bool isLoading = false;
  final Random random = Random();

  @override
  bool get wantKeepAlive => true; // Ensure the state is kept alive

  @override
  void initState() {
    super.initState();
    fetchDataForAllCategories();
  }

  Future<void> fetchDataForAllCategories() async {
    final categories = [
      'Thriller', 'Horror', 'History', 'Fiction', 'Comics & Graphic Novels',
      'Art', 'Religion', 'Philosophy', 'Action and Adventure', 'Poetry',
      'Romance', 'Mystery', 'Fantasy', 'Science', 'Childrens Fiction',
      'Technology', 'Crime Fiction', 'Education',
    ];

    for (String category in categories) {
      fetchCategoryData(category);
    }
  }

  Future<void> fetchCategoryData(String category) async {
    setState(() {
      isCategoryLoading[category] = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'https://www.googleapis.com/books/v1/volumes?q=$category&key=$apiKey&startIndex=${random.nextInt(10)}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['items'] ?? [];
        setState(() {
          booksByCategory[category] = items.map((item) => Book.fromJson(item)).toList();
          booksByCategory[category]!.shuffle(); // Shuffle the books list
          isCategoryLoading[category] = false;
        });
      } else {
        throw Exception('Failed to load book details');
      }
    } catch (e) {
      print('Error fetching data for $category: $e');
      setState(() {
        isCategoryLoading[category] = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUi screenUi = ScreenUi(context);
    super.build(context); // This ensures the mixin is properly integrated

    return Scaffold(
      appBar: appBar(),
      body: ListView(
        children: booksByCategory.entries.map((entry) {
          String category = entry.key;
          List<Book>? books = entry.value;
          bool loading = isCategoryLoading[category] ?? true;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: screenUi.scaleWidth(8.0)),
                child: Text(
                  category,
                  style: TextStyle(
                    color: Color(0xEEEEEEEE),
                    fontSize: screenUi.scaleWidth(15.0),
                  ),
                ),
              ),
              SizedBox(height: screenUi.scaleWidth(8.0)),
                isLoading
              ? const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Color(0xFFFF6500)),
                    ),
                  ),
                )
                  : SizedBox(
                      height: screenUi.scaleWidth(220.0),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                            left: screenUi.scaleWidth(8.0),
                            right: screenUi.scaleWidth(8.0)),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookDetails(book: books[index]),
                                ),
                              );
                            },
                            child: Container(
                              width: screenUi.scaleWidth(130.0),
                              decoration: BoxDecoration(
                                color: const Color(0xff323232),
                                borderRadius: BorderRadius.circular(screenUi.scaleWidth(8.0)),
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        width: screenUi.scaleWidth(120.0),
                                        height: screenUi.scaleWidth(150.0),
                                        margin: EdgeInsets.only(top: screenUi.scaleWidth(5.0)),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(screenUi.scaleWidth(8.0)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.3),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(3, 3),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(screenUi.scaleWidth(5.0)),
                                          child: Image.network(
                                            books[index].thumbnailUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: screenUi.scaleWidth(5.0),
                                            left: screenUi.scaleWidth(8.0),
                                            right: screenUi.scaleWidth(8.0)),
                                        child: Center(
                                          child: Text(
                                            books[index].title,
                                            style: TextStyle(
                                              color: Color(0xEEEEEEEE),
                                              fontSize: screenUi.scaleWidth(10.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    bottom: screenUi.scaleWidth(5.0),
                                    left: screenUi.scaleWidth(5.0),
                                    child: Text(
                                      'Year: ${books[index].publishedDate}',
                                      style: TextStyle(
                                        color: Color(0xFFFF6500),
                                        fontSize: screenUi.scaleWidth(10.0),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: screenUi.scaleWidth(5.0),
                                    right: screenUi.scaleWidth(5.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: screenUi.scaleWidth(10.0),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          books[index].ratingsCount.toString(),
                                          style: TextStyle(
                                            color: Color(0xEEEEEEEE),
                                            fontSize: screenUi.scaleWidth(10.0),
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
                        separatorBuilder: (context, index) => SizedBox(
                          width: screenUi.scaleWidth(8.0),
                        ),
                        itemCount: books.length ?? 0,
                      ),
                    ),
              SizedBox(height: screenUi.scaleWidth(8.0)),
            ],
          );
        }).toList(),
      ),
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
    );
  }
}
