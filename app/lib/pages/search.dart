import 'dart:convert';

import 'package:book_store/API/ui.dart';
import 'package:book_store/pages/book_search.dart';
import 'package:flutter/material.dart';

import 'package:book_store/models/searchBook.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import 'home.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<SearchBook> searchResults = [];
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();
  String lastQuery = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Restore the previous search if any
    if (lastQuery.isNotEmpty) {
      searchBooks(lastQuery);
    }
  }

  Future<void> searchBooks(String query) async {
    if (query.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'https://www.googleapis.com/books/v1/volumes?q=$query&key=$apiKey'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['items'] ?? [];
        setState(() {
          searchResults =
              items.map((item) => SearchBook.fromJson(item)).toList();
          lastQuery = query;
        });
      } else {
        throw Exception('Failed to load book details');
      }
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
    ScreenUi screenUi = ScreenUi(context);
    return Scaffold(
      appBar: appBar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _searchField()),
          SliverPadding(
              padding: EdgeInsets.only(top: screenUi.scaleWidth(10.0))),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                  left: screenUi.scaleWidth(8.0),
                  right: screenUi.scaleWidth(8.0)),
              child: Text(
                'Results',
                style: TextStyle(
                  color: Color(0xEEEEEEEE),
                  fontSize: screenUi.scaleWidth(18.0),
                ),
              ),
            ),
          ),
          SliverPadding(
              padding: EdgeInsets.only(top: screenUi.scaleWidth(8.0))),
          isLoading
              ? const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Color(0xFFFF6500)),
                    ),
                  ),
                )
              : SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(
                        left: screenUi.scaleWidth(8.0),
                        right: screenUi.scaleWidth(8.0)),
                    height: screenUi
                        .scaleWidth(220.0), // Adjust height to fit the content
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final book = searchResults[index];
                        return _buildBookItem(book);
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        width: screenUi.scaleWidth(8.0),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildBookItem(SearchBook book) {
    ScreenUi screenUi = ScreenUi(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetails(book: book),
          ),
        );
      },
      child: Container(
        child: Container(
          width: screenUi.scaleWidth(130.0),
          decoration: BoxDecoration(
            color: Color(0xff323232),
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
                      borderRadius:
                          BorderRadius.circular(screenUi.scaleWidth(8.0)),
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
                      borderRadius:
                          BorderRadius.circular(screenUi.scaleWidth(5.0)),
                      child: Image.network(
                        book.thumbnailUrl,
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
                        book.title,
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
                  'Year: ${book.publishedDate}',
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
                     size: screenUi.scaleWidth(10.0)
                    ),
                    const SizedBox(width: 4),
                    Text(
                      book.ratingsCount.toString(),
                      style:  TextStyle(
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
      ),
    );
  }

  Container _searchField() {
    ScreenUi screenUi = ScreenUi(context);
    return Container(
      margin: EdgeInsets.only(
          left: screenUi.scaleWidth(8.0), right: screenUi.scaleWidth(8.0)),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: const Color(0xFF393E46).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0)
      ]),
      child: TextField(
        controller: searchController,
        onSubmitted: (query) => searchBooks(query),
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xff323232),
            contentPadding: EdgeInsets.all(screenUi.scaleWidth(8.0)),
            hintText: 'Search book',
            hintStyle: TextStyle(
              color: Color(0xEEEEEEEE),
              fontSize: screenUi.scaleWidth(16.0),
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.all(screenUi.scaleWidth(8.0)),
              child: SvgPicture.asset(
                'assets/icons/search-svgrepo-com.svg',
                color: const Color(0xEEEEEEEE),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(screenUi.scaleWidth(8.0)),
              borderSide: BorderSide.none,
            )),
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
