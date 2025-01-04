import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('login')),
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool('isLoggedIn', true);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
              );
            },
            child: Text('login')
        ),
      ),
    );
  }
}