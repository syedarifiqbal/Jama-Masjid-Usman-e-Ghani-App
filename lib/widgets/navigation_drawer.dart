import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerNavigation extends StatefulWidget {
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  bool? loggedIn;
  bool? isAdmin;
  String? _name;
  String? _email;
  late SharedPreferences _prefs;

  void _checkLogin() async {
    setState(() {
      loggedIn = _prefs.getBool("loggedIn");
      _name = _prefs.getString("name");
      _email = _prefs.getString("email");
      isAdmin = _prefs.getBool('isAdmin');
    });
  }

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((value) {
      _prefs = value;
      _checkLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: loggedIn == true
                ? Column(
                    children: [
                      CircleAvatar(
                        child: Icon(
                          Icons.verified_user,
                          color: Colors.green[800],
                        ),
                      ),
                      Text(
                        _name ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _email ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      const Expanded(
                        child: Text(""),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.popAndPushNamed(context, '/login');
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              // Close drawer
              Navigator.pop(context);
            },
          ),
          if (loggedIn == true && isAdmin == true)
            ListTile(
              title: const Text('Transactions'),
              onTap: () {
                // Close drawer
                Navigator.pop(context);
                Navigator.pushNamed(context, '/transactions');
              },
            ),
          if (loggedIn == true && isAdmin == true)
            ListTile(
              title: const Text('Record Expense'),
              onTap: () {
                // Close drawer and navigate to record expense screen
                Navigator.pop(context);
                Navigator.pushNamed(context, '/recordExpense');
              },
            ),
          if (loggedIn == true && isAdmin == true)
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                // Close drawer and navigate to settings screen
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
          if (loggedIn == true)
            ListTile(
              title: TextButton(
                child: const Text('Logout'),
                onPressed: () {
                  _prefs.setBool('loggedIn', false);
                  Navigator.popAndPushNamed(context, '/login');
                },
              ),
            )
        ],
      ),
    );
  }
}

// class navigation_drawer extends StatelessWidget {
//   const navigation_drawer({
//     super.key,
//   });

  

  
// }
