import 'dart:convert';
import 'package:book_store/API/api.dart';
import 'package:book_store/API/ui.dart';

import 'package:book_store/models/bookModel.dart';
import 'package:book_store/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetails extends StatefulWidget {
  final Book book;

  const BookDetails({super.key, required this.book});

  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  bool isOverviewSelected = true;

  Future<String?> retrieveAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('api_token');
  }

  Future<void> resetAuthToken() async {
    await deleteAuthToken();
    // Any additional logic to reset the app state can be added here
  }

  Future<void> deleteAuthToken() async {
    final  prefs = await SharedPreferences.getInstance();
    await prefs.remove('api_token');
  }

  Future<void> _checkLoginStatus() async {
    String? token = await retrieveAuthToken();

    if (token != null) {
      // Token exists, add to list
      _addToList();
    } else {
      // No token found, navigate to Login Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  Future<void> _addToList() async {
    final data = {
      'title': widget.book.title.toString(),
      'authors': widget.book.authors.toString(),
      'publisher': widget.book.publisher.toString(),
      // 'description': widget.book.description,
      'categories': widget.book.categories.toString(),
      'thumbnailUrl': widget.book.thumbnailUrl,
      'publishedDate': widget.book.publishedDate.toString(),
    };
    final result = await Api().postToCartData(route: '/addToCart', data: data);
    final response = jsonDecode(result.body);

    if (response['status']) {
      // Successfully added to the database
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Book added to list successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Failed to add to the database
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add book to list.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUi screenUi = ScreenUi(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 1.8,
                  width: double.infinity,
                  child: Image.network(
                    widget.book.thumbnailUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: screenUi.scaleWidth(10.0),
                  left: screenUi.scaleWidth(10.0),
                  right: screenUi.scaleWidth(
                      10.0), // Added to restrict text within the container's width
                  child: Text(
                    widget.book.title,
                    style: TextStyle(
                      color: Color(0xEEEEEEEE),
                      fontSize: screenUi.scaleWidth(30.0),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: null, // Allows text to wrap to a new line
                    overflow: TextOverflow
                        .visible, // Ensures overflow text is visible
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenUi.scaleWidth(10.0),
                horizontal: screenUi.scaleWidth(15.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.playlist_add,
                          color: Color(0xFFFF6500),
                          size: screenUi.scaleWidth(25.0),
                        ),
                        onPressed: _checkLoginStatus,
                      ),
                      Text(
                        'Add to List',
                        style: TextStyle(
                          fontSize: screenUi.scaleWidth(13.0),
                          color: Color(0xEEEEEEEE),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.read_more,
                          color: Color(0xFFFF6500),
                          size: screenUi.scaleWidth(25.0),
                        ),
                        onPressed: () async {
                          if (await canLaunch(widget.book.previewLink)) {
                            await launch(widget.book.previewLink);
                          } else {
                            throw 'Could not launch $widget.book.previewLink';
                          }
                        },
                      ),
                      Text(
                        'Where to read',
                        style: TextStyle(
                          fontSize: screenUi.scaleWidth(13.0),
                          color: Color(0xEEEEEEEE),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.menu_book_outlined,
                          color: Color(0xFFFF6500),
                          size: screenUi.scaleWidth(25.0),
                        ),
                        onPressed: resetAuthToken,
                      ),
                      Text(
                        'book',
                        style: TextStyle(
                          fontSize: screenUi.scaleWidth(13.0),
                          color: Color(0xEEEEEEEE),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey,
                    width: 0.8,
                  ),
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.8,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height:
                          screenUi.scaleWidth(8.0)), // Adjust spacing as needed
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.book.maturityRating == "NOT_MATURE"
                            ? "all ages"
                            : "18+",
                        style: TextStyle(
                          fontSize: screenUi.scaleWidth(10.0),
                          color: Color(0xEEEEEEEE),
                        ),
                      ),
                      Text(
                        " · ",
                        style: TextStyle(
                          fontSize: screenUi.scaleWidth(10.0),
                          color: Color(0xEEEEEEEE),
                        ),
                      ),
                      Text(
                        '${widget.book.printedPageCount.toString()} pages',
                        style: TextStyle(
                          fontSize: screenUi.scaleWidth(10.0),
                          color: Color(0xEEEEEEEE),
                        ),
                      ),
                      Text(
                        " · ",
                        style: TextStyle(
                          fontSize: screenUi.scaleWidth(10.0),
                          color: const Color(0xEEEEEEEE),
                        ),
                      ),
                      Text(
                        widget.book.language,
                        style: TextStyle(
                          fontSize: screenUi.scaleWidth(10.0),
                          color: Color(0xEEEEEEEE),
                        ),
                      ),
                      Text(
                        " · ",
                        style: TextStyle(
                          fontSize: screenUi.scaleWidth(10.0),
                          color: const Color(0xEEEEEEEE),
                        ),
                      ),
                      Text(
                        widget.book.fullDate,
                        style: TextStyle(
                          fontSize: screenUi.scaleWidth(10.0),
                          color: Color(0xEEEEEEEE),
                        ),
                      ),
                      Text(
                        " · ",
                        style: TextStyle(
                          fontSize: screenUi.scaleWidth(10.0),
                          color: Color(0xEEEEEEEE),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: screenUi.scaleWidth(13.0),
                          ),
                          SizedBox(width: screenUi.scaleWidth(4.0)),
                          Text(
                            widget.book.ratingsCount.toString(),
                            style: TextStyle(
                              color: Color(0xEEEEEEEE),
                              fontSize: screenUi.scaleWidth(10.0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                      height:
                          screenUi.scaleWidth(8.0)), // Adjust spacing as needed
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenUi.scaleWidth(8.0),
                  vertical: screenUi.scaleWidth(8.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isOverviewSelected = true;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenUi.scaleWidth(8.0)),
                      decoration: BoxDecoration(
                        border: isOverviewSelected
                            ? const Border(
                                bottom: BorderSide(
                                  color: Color(0xFFFF6500),
                                  width: 2.0,
                                ),
                              )
                            : null,
                      ),
                      child: Text(
                        'Overview',
                        style: TextStyle(
                          color: isOverviewSelected
                              ? const Color(0xFFFF6500)
                              : Colors.grey,
                          fontSize: screenUi.scaleWidth(18.0),
                          fontWeight: isOverviewSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenUi.scaleWidth(8.0)),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isOverviewSelected = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenUi.scaleWidth(8.0),
                      ),
                      decoration: BoxDecoration(
                        border: !isOverviewSelected
                            ? const Border(
                                bottom: BorderSide(
                                  color: Color(0xFFFF6500),
                                  width: 2.0,
                                ),
                              )
                            : null,
                      ),
                      child: Text(
                        'Details',
                        style: TextStyle(
                          color: !isOverviewSelected
                              ? const Color(0xFFFF6500)
                              : Colors.grey,
                          fontSize: screenUi.scaleWidth(18.0),
                          fontWeight: !isOverviewSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenUi.scaleWidth(8.0),
                  vertical: screenUi.scaleWidth(8.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isOverviewSelected)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenUi.scaleWidth(8.0),
                                  vertical: screenUi.scaleWidth(5.0)),
                              decoration: BoxDecoration(
                                color: const Color(0xff323232),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.book.publishedDate,
                                style: TextStyle(
                                  color: Color(0xEEEEEEEE),
                                  fontSize: screenUi.scaleWidth(12.0),
                                ),
                              ),
                            ),
                            SizedBox(width: screenUi.scaleWidth(8.0)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenUi.scaleWidth(8.0),
                                  vertical: screenUi.scaleWidth(4.0)),
                              decoration: BoxDecoration(
                                color: const Color(0xff323232),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.book.contentVersion,
                                style: TextStyle(
                                  color: Color(0xEEEEEEEE),
                                  fontSize: screenUi.scaleWidth(12.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenUi.scaleWidth(8.0)),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: screenUi.scaleWidth(8.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Description',
                                style: TextStyle(
                                  color: Color(0xEEEEEEEE),
                                  fontSize: screenUi.scaleWidth(18.0),
                                ),
                              ),
                              SizedBox(height: screenUi.scaleWidth(5.0)),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  widget.book.description,
                                  style: TextStyle(
                                    color: Color(0xEEEEEEEE),
                                    fontSize: screenUi.scaleWidth(12.0),
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: screenUi.scaleWidth(8.0)),
                      width: double
                          .infinity, // Ensure the container spans full width
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius:
                            BorderRadius.circular(screenUi.scaleWidth(8.0)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(screenUi.scaleWidth(8.0)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      'Publisher: ${widget.book.publisher}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenUi.scaleWidth(8.0)),
                                  Center(
                                    child: Text(
                                      'Authors: ${widget.book.authors}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenUi.scaleWidth(8.0)),
                                  Center(
                                    child: Text(
                                      'Categories: ${widget.book.categories}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenUi.scaleWidth(8.0)),
                                  Center(
                                    child: Text(
                                      'Language: ${widget.book.language}', // Replace with your name or organization
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: screenUi.scaleWidth(110.0),
                              // height: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight:
                                      Radius.circular(screenUi.scaleWidth(8.0)),
                                  bottomRight:
                                      Radius.circular(screenUi.scaleWidth(8.0)),
                                ),
                              ),
                              child: Image.network(
                                widget.book.thumbnailUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
