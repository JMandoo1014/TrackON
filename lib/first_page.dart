import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_page.dart';
import 'signup_page.dart';
import 'login_page.dart';

class FirstPage extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFE7D7AB),
      body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Text(
                    'TrackON',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50
                    ),
                    ),
                  ),
                Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                          padding: EdgeInsets.all(13),
                          child: ElevatedButton(
                              onPressed: () async {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setBool('isLoggedIn', true);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoginPage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                                )
                              ),
                              child: Text('로그인')
                          ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(13),
                        child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => SignupPage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
                            ),
                            child: Text('회원가입')
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
      )
    );
  }
}