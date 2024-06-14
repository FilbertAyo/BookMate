
import 'package:book_store/models/bottomNavigation.dart';
import 'package:book_store/models/searchBook.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetails extends StatefulWidget {
  final SearchBook book;

  BookDetails({super.key, required this.book});

  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  bool isOverviewSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            bookImage(),
            additionalInfo(),
            sec(),
            toggleSection(),
            overviewOrReviews(),
          ],
        ),
      ),
      //  bottomNavigationBar: const BottomNavigation(),
    );
  }

  Container sec() {
    return Container(
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
          const SizedBox(height: 10), // Adjust spacing as needed
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.book.maturityRating == "NOT_MATURE" ? "all ages" : "18+",
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xEEEEEEEE),
                ),
              ),
              const Text(
                " · ",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xEEEEEEEE),
                ),
              ),
              Text(
                '${widget.book.printedPageCount.toString()} pages',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xEEEEEEEE),
                ),
              ),
              const Text(
                " · ",
                style: TextStyle(
                  fontSize: 20,
                  color: const Color(0xEEEEEEEE),
                ),
              ),
              Text(
                widget.book.language,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xEEEEEEEE),
                ),
              ),
              const Text(
                " · ",
                style: TextStyle(
                  fontSize: 20,
                  color: const Color(0xEEEEEEEE),
                ),
              ),
              Text(
                widget.book.fullDate,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xEEEEEEEE),
                ),
              ),
              const Text(
                " · ",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xEEEEEEEE),
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.book.ratingsCount.toString(),
                    style: const TextStyle(
                      color: Color(0xEEEEEEEE),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10), // Adjust spacing as needed
        ],
      ),
    );
  }

  Widget bookImage() {
    return Stack(
      children: [
        Container(
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
          bottom: 10,
          left: 10,
          right: 10, // Added to restrict text within the container's width
          child: Text(
            widget.book.title,
            style: const TextStyle(
              color: Color(0xEEEEEEEE),
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
            maxLines: null, // Allows text to wrap to a new line
            overflow: TextOverflow.visible, // Ensures overflow text is visible
          ),
        ),
      ],
    );
  }

  Widget additionalInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 30,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.playlist_add,
                  color: Color(0xFFFF6500),
                  size: 40,
                ),
                onPressed: () {
                  // Add to list action
                },
              ),
              const Text(
                'Add to List',
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xEEEEEEEE),
                ),
              ),
            ],
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.read_more,
                  color: Color(0xFFFF6500),
                  size: 40,
                ),
                onPressed: () async {
                  if (await canLaunch(widget.book.previewLink)) {
                    await launch(widget.book.previewLink);
                  } else {
                    throw 'Could not launch $widget.book.previewLink';
                  }
                },
              ),
              const Text(
                'Where to read',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xEEEEEEEE),
                ),
              ),
            ],
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.book,
                  color: Color(0xFFFF6500),
                  size: 40,
                ),
                onPressed: () {
                  // Rating action
                },
              ),
              const Text(
                'book',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xEEEEEEEE),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget toggleSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                  fontSize: 20,
                  fontWeight:
                      isOverviewSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () {
              setState(() {
                isOverviewSelected = false;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                  fontSize: 20,
                  fontWeight:
                      !isOverviewSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget overviewOrReviews() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xff323232),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.book.publishedDate,
                        style: const TextStyle(
                          color: Color(0xEEEEEEEE),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xff323232),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.book.contentVersion,
                        style: const TextStyle(
                          color: Color(0xEEEEEEEE),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(
                          color: Color(0xEEEEEEEE),
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: double.infinity,
                        child: Text(
                          widget.book.description,
                          style: const TextStyle(
                            color: Color(0xEEEEEEEE),
                            fontSize: 15,
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
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity, // Ensure the container spans full width
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
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
                          const SizedBox(height: 6),
                          Center(
                            child: Text(
                              'Authors: ${widget.book.authors}',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Center(
                            child: Text(
                              'Categories: ${widget.book.categories}',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
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
                      width: 110,
                      // height: 300,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
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
    );
  }
}
