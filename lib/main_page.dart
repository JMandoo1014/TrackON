import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackon/first_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Main Page'),
        actions: [
          IconButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('isLoggedIn', false);

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => FirstPage()),
                );
              },
              icon: Icon(Icons.logout)
          )
        ],
      ),
      body: Center(child: Text('Main Page Demo')),
    );
  }
}