import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usman_e_ghani/services/api_service.dart';

import '../helpers/common.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text;
      String password = _passwordController.text;

      // Perform authentication here, e.g., make API call to check credentials

      // For demo purposes, we'll use shared preferences to store login status
      SharedPreferences prefs = await SharedPreferences.getInstance();

      try {
        Map<String, String> body = {
          'email': username,
          'password': password,
        };

        Response response = await ApiService(context).post('/login', (body));

        print(response.body);

        if (response.statusCode >= 200 && response.statusCode < 300) {
          _formKey.currentState!.reset();
          await prefs.setBool('loggedIn', true);
          var data = jsonDecode(response.body);
          await prefs.setString('access_token', data['access_token']);
          await prefs.setBool('isAdmin', data['user']['is_admin']);
          await prefs.setString('name', data['user']['name']);
          await prefs.setString('email', data['user']['email']);
          await prefs.setInt('id', data['user']['id']);
          // Navigate to home screen
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          showToast(jsonDecode(response.body)['message']);
        }
      } catch (e) {
        showToast(e.toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      bool? isLoggedIn = value.getBool('loggedIn');
      print(value.getString('access_token'));
      if (isLoggedIn != null && isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
    // Fetch initial expenses data when the screen is loaded
    // _fetchExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
              TextFormField(
                controller: _passwordController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
