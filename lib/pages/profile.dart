import 'dart:async';
import 'dart:convert';

import 'package:book_store/API/api.dart';

import 'package:book_store/pages/home.dart';
import 'package:book_store/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name;
  String? email;
  String? token;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      email = prefs.getString('email');
      token = prefs.getString('api_token');
    });
  }

  Future<void> resetAuthToken() async {
    await deleteAuthToken();
    // Any additional logic to reset the app state can be added here
  }

  Future<void> deleteAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('api_token');
  }

  Future<void> logoutUser() async {
    setState(() {
    });

    // Timer to handle timeout
    var timer = Timer(const Duration(seconds: 20), () {
      setState(() {
        // _showErrorPage(); // Call function to display error page
      });
    });

    final result = await Api().logoutData(route: '/auth/logout');
    final response = jsonDecode(result.body);
    timer.cancel();
    if (response['status']) {
      // Navigate to landing page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      await resetAuthToken();
      // Show registration success banner
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User logged out successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Login failed
      print('Failed to logout: ${response['message']}');
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: ${response['message']}'),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: token == null || token!.isEmpty
          // ignore: prefer_const_constructors
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Please login to your account or Register",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xFFFF6500)),
                      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(horizontal: 60),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?q=80&w=1385&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.edit,
                                size: 16, color: Colors.white),
                            onPressed: () => {}, // Handle edit profile action
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '$name',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const Text(
                    'Book Enthusiast',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.brightness_medium,
                            color: Colors.blue),
                        onPressed: () => {}, // Handle Twitter link action
                      ),
                      IconButton(
                        icon: const Icon(Icons.nat_sharp, color: Colors.blue),
                        onPressed: () => {}, // Handle LinkedIn link action
                      ),
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.blue),
                        onPressed: () => {}, // Handle GitHub link action
                      ),
                    ],
                  ),
                  const Divider(thickness: 1),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: Text(
                      '$email',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  // const ListTile(
                  //   leading: Icon(Icons.phone),
                  //   title: Text('255-7567-8900'),
                  // ),
                  // const SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () => {}, // Handle edit profile button action
                  //   child: const Text('Edit Profile'),
                  // ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                      onPressed: logoutUser, // Handle logout button action
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize:
                            const Size.fromHeight(50), // Make button long
                      ),
                      child: const Text('Logout',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),

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
    );
  }
}
