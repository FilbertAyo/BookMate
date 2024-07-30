import 'package:book_store/API/api.dart';

import 'package:book_store/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoggingin = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> loginUser() async {
    setState(() {
      _isLoggingin = true;
    });

    if (!_formKey.currentState!.validate()) {
      setState(() {
        _isLoggingin = false;
      });
      return;
    }

    final data = {
      'email': emailController.text.toString(),
      'password': passwordController.text.toString()
    };

    var timer = Timer(const Duration(seconds: 20), () {
      setState(() {
        _isLoggingin = false;
        _showErrorPage();
      });
    });

    try {
      final result =
          await Api().postLoginData(route: '/auth/login', data: data);
      final response = jsonDecode(result.body);
      timer.cancel();

      if (response['status']) {
        final token = response['token'];
        await Api().storeAuthToken(token);

        // Fetch user details
        final userDetailsResult = await Api().getUserDetails();
        final userDetailsResponse = jsonDecode(userDetailsResult.body);

        print('${userDetailsResponse['data']['email']}');
        // Store user information locally
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', userDetailsResponse['data']['name']);
        await prefs.setString('email', userDetailsResponse['data']['email']);
        await prefs.setString('authToken', token);

        //this code ensure user return to previous page when registered
        Navigator.pop(context, true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User logged in successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print('Failed to login: ${response['error']}');
        if (response['error'] != null) {
          String errorMessage = '';
          int errorNumber = 1;
          response['error'].forEach((field, errors) {
            errors.forEach((error) {
              errorMessage += '$errorNumber. $error\n';
              errorNumber++;
            });
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed:\n$errorMessage'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          String message = response['message'];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed:\n$message'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Error during login: $e');
      timer.cancel();
      setState(() {
        _isLoggingin = false;
        _showErrorPage();
      });
    } finally {
      setState(() {
        _isLoggingin = false;
      });
    }
  }

  void _showErrorPage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Login request timed out. Please try again.'),
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
                      "Sign in",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6500),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white),
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
                      filled: true,
                      fillColor: Colors.black,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: const BorderSide(
                          color: Color(0xff0159a1),
                        ),
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
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      loginUser();
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
                    child: _isLoggingin
                        ? const CircularProgressIndicator()
                        : const Text("Login",
                            style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()),
                        );
                      },
                      child: const Text(
                        "Dont have an account? Register",
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
