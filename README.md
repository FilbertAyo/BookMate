# book_store

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



<!-- hint -->

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/team.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Team> teams = [];
  static const String apiKey =
      'live_nbSMR6pNnYTZsTa7zljS8TI8WPDt6P0qoTlMe3Ra3DQjyMlMGIHNn8ODWLleJXlj'; // Your API Key

  @override
  void initState() {
    super.initState();
    getTeams();
  }

Future<void> getTeams() async {
  final headers = {'Authorization': 'Bearer $apiKey'};

  try {
    var response = await http.get(
      Uri.parse('https://api.thecatapi.com/v1/images/search?limit=9'),
      // headers: headers,
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      setState(() {
        teams = (jsonData as List).map((teamData) {
          var breedData = teamData['breeds'] as List?;
          var origin = breedData != null && breedData.isNotEmpty ? breedData[0]['origin'] : 'Unknown';
          var name = breedData != null && breedData.isNotEmpty ? breedData[0]['name'] : 'Unknown';
          var weight = breedData != null && breedData.isNotEmpty ? breedData[0]['weight']['metric'] : 'Unknown';

          return Team(
            id: teamData['id'],
            width: teamData['width'],
            height: teamData['height'],
            weight: weight,
            imageUrl: teamData['url'],
            origin: origin,
            name: name,
          );
        }).toList();
      });
    } else {
      // Handle non-200 responses here
      print('Failed to load teams. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teams')),
      body: teams.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(teams[index].imageUrl),
                  title: Text(
                    teams[index].id,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'ID: ${teams[index].id}, Width: ${teams[index].width}, Height: ${teams[index].height}, Weight: ${teams[index].weight}, Origin: ${teams[index].origin}',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
    );
  }
}



//category selection




  // Widget _categoryname() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 10),
  //     child: DropdownButton<String>(
  //       value: selectedCategory,
  //       items: categories.map((String category) {
  //         return DropdownMenuItem<String>(
  //           value: category,
  //           child: Text(category),
  //         );
  //       }).toList(),
  //       onChanged: (String? newCategory) {
  //         if (newCategory != null) {
  //           setState(() {
  //             selectedCategory = newCategory;
  //             updateCategory(newCategory);
  //           });
  //         }
  //       },
  //     ),
  //   );
  // }



  //get

  Container _category() {
    return Container(
      height: 250,
      child: books.isEmpty
          ? const Center(
              child: SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Color(0xFFFF6500)),
                  strokeWidth: 1.0,
                ),
              ),
            )
          : ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
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
                              margin: const EdgeInsets.only(
                                top: 5,
                              ),
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
                                  books[index].thumbnailUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 5, left: 10, right: 10),
                              child: Text(
                                books[index].title,
                                style: const TextStyle(
                                  color: Color(0xEEEEEEEE),
                                  fontSize: 15,
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
                width: 15,
              ),
              itemCount: books.length,
            ),
    );
  }