import 'package:book_store/API/api.dart';
import 'package:book_store/pages/home.dart';

import 'package:book_store/pages/login.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _isRegistering = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) {
      // Form is not valid, do not proceed with registration
      return;
    }
    setState(() {
      _isRegistering = true;
    });

    final data = {
      'email': emailController.text.toString(),
      'name': nameController.text.toString(),
      'password': passwordController.text.toString(),
      'password_confirmation': passwordConfirmationController.text.toString()
    };

    // Timer to handle timeout
    var timer = Timer(const Duration(seconds: 20), () {
      setState(() {
        _isRegistering = false;
        _showErrorPage(); // Call function to display error page
      });
    });

    try {
      final result =
          await Api().postRegisterData(route: '/auth/register', data: data);
      final response = jsonDecode(result.body);
      timer.cancel(); // Cancel timer if successful response

      if (response['status']) {
        final token = response['token'];
        await Api().storeAuthToken(token);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', nameController.text);
        await prefs.setString('email', emailController.text);
        await prefs.setString('authToken', token);
        // Show registration success banner
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User registered successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // Show error message
        String errorMessage = '';
        int errorNumber = 1;
        response['error'].forEach((field, errors) {
          errors.forEach((error) {
            errorMessage += '$errorNumber. $error \n';
            errorNumber++;
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed:\n $errorMessage'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle any other errors
      print('Error during registration: $e');
      timer.cancel();
      setState(() {
        _isRegistering = false;
        _showErrorPage(); // Call function to display error page
      });
    } finally {
      setState(() {
        _isRegistering = false;
      });
    }
  }

  void _showErrorPage() {
    // Replace this with your actual error page logic
    // You can display a dialog or navigate to a separate error screen
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content:
              const Text('Registration request timed out. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6500),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(
                          color: Colors.white), // Set label color to white
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.black,

                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .grey), // Set the border color to white when focused
                      ),
                    ),
                    style: const TextStyle(
                        color: Colors
                            .white), // Set the entered text color to white
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.black,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .grey), // Set the border color to white when focused
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.white),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.black,
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .grey), // Set the border color to white when focused
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xFFFF6500),
                        ),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    obscureText: _obscurePassword,
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Confirm password',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.black,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .grey), // Set the border color to white when focused
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    obscureText: _obscurePassword,
                    controller: passwordConfirmationController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password confirmation is required';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      registerUser();
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xFFFF6500)),
                      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.all(15),
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      overlayColor: WidgetStateProperty.all<Color>(Colors.teal),
                    ),
                    child: _isRegistering
                        ? const CircularProgressIndicator()
                        : const Text("Register",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            )),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        "Already have an account? Login",
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
