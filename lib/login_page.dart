import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPhoneStage = true; // 현재 단계: 전화번호 입력(true), 비밀번호 입력(false)
  bool _isPasswordVisible = false; // 비밀번호 보이기 여부
  bool _isButtonEnabled = false; // 버튼 활성화 상태

  @override
  void initState() {
    super.initState();

    // 입력값 변경에 따라 버튼 활성화 상태를 갱신
    _phoneController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 버튼 상태 업데이트
  void _updateButtonState() {
    setState(() {
      if (_isPhoneStage) {
        _isButtonEnabled = _phoneController.text.isNotEmpty;
      } else {
        _isButtonEnabled = _passwordController.text.isNotEmpty;
      }
    });
  }

  // 로그인 처리
  Future<void> _onLogin() async {
    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();

    if (phone.isNotEmpty && password.isNotEmpty) {
      // 서버에 로그인 요청 보내기
      final response = await http.post(
        Uri.parse('http://13.49.74.31:3000/login'), // AWS JMandoo server ip
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phone': phone,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // 로그인 성공
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("로그인 성공!")),
        );
      } else {
        // 로그인 실패
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("전화번호 또는 비밀번호가 잘못되었습니다.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("전화번호와 비밀번호를 입력해주세요")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE7D7AB),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '로그인',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: _isPhoneStage
                      ? _buildPhoneInput() // 전화번호 입력
                      : _buildPasswordInput(), // 비밀번호 입력
                ),
              ),
              SizedBox(height: 40.0),
              Center(
                child: ElevatedButton(
                  onPressed: _isButtonEnabled
                      ? () {
                    if (_isPhoneStage) {
                      setState(() => _isPhoneStage = false);
                    } else {
                      _onLogin();
                    }
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonEnabled
                        ? Colors.orangeAccent
                        : Colors.grey, // 비활성화 시 버튼 색상
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: Size(60, 60),
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 35.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Container(
      key: ValueKey(1),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _phoneController,
        decoration: InputDecoration(labelText: '전화번호'),
        keyboardType: TextInputType.phone,
      ),
    );
  }

  Widget _buildPasswordInput() {
    return Container(
      key: ValueKey(2),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _passwordController,
        decoration: InputDecoration(
          labelText: '비밀번호',
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
        obscureText: !_isPasswordVisible,
      ),
    );
  }
}