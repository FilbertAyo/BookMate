import 'dart:convert';
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
    return Scaffold(
      appBar: appBar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _searchField()),
          const SliverPadding(padding: EdgeInsets.only(top: 20)),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Results',
                style: TextStyle(
                  color: Color(0xEEEEEEEE),
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(top: 10)),
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
                    padding: EdgeInsets.only(left: 10, right: 10),
                    height: 260, // Adjust height to fit the content
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final book = searchResults[index];
                        return _buildBookItem(book);
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 10,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildBookItem(SearchBook book) {
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
                      borderRadius: BorderRadius.circular(8),
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
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        book.thumbnailUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                    child: Center(
                      child: Text(
                        book.title,
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
                  'Year: ${book.publishedDate}',
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
                      book.ratingsCount.toString(),
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
      ),
    );
  }

  Container _searchField() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
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
            contentPadding: const EdgeInsets.all(10),
            hintText: 'Search book',
            hintStyle: const TextStyle(
              color: Color(0xEEEEEEEE),
              fontSize: 18,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                'assets/icons/search-svgrepo-com.svg',
                color: const Color(0xEEEEEEEE),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            )),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.grey[900],
      // centerTitle: true,
      // title: const Text(
      //   'Book Search',
      //   style: TextStyle(
      //     color: Color(0xEEEEEEEE),
      //     fontSize: 20,
      //   ),
      // ),
      leading: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset(
            'assets/icons/left-arrow-backup-2-svgrepo-com.svg',
            height: 15,
            width: 15,
            color: const Color(0xEEEEEEEE),
          ),
        ),
      ),
    );
  }
}
