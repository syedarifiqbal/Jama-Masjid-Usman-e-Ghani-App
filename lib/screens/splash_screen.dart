import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  @override
  void initState() {
    super.initState();

    // Call the delayed function to navigate to the home page after 5 seconds
    _timer = Timer(Duration(seconds: 3), () async {
      await Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Call the Timer function to navigate to the home page after 5 seconds

    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/playstore.png'),
      ),
    );
  }
}
