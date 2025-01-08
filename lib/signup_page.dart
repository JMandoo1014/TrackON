import 'package:flutter/material.dart';
import 'package:trackon/first_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPage();
}

class _SignupPage extends State<SignupPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPhoneStage = true; // 현재 단계: 전화번호 입력(true), 비밀번호 입력(false)
  bool _isPasswordVisible = false; // 비밀번호 보이기 여부
  bool _isButtonEnabled = false; // 버튼 활성화 상태

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      if (_isPhoneStage) {
        _isButtonEnabled = _phoneController.text.isNotEmpty;
      } else {
        _isButtonEnabled = _passwordController.text.isNotEmpty;
      }
    });
  }

  // 회원가입 처리 (Node.js API 호출)
  Future<void> _onSignUp() async {
    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();

    if (phone.isNotEmpty && password.isNotEmpty) {
      try {
        final url = 'http://13.49.74.31:3000/signup'; // 실제 서버 IP 주소로 변경
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'phone': phone,
            'password': password,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("회원가입 성공!")),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FirstPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("회원가입 실패: ${response.body}")),
          );
        }
      } catch (e) {
        print("회원가입 오류: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("서버와 연결 실패")),
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
            children: [
              Text(
                '회원가입',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: _isPhoneStage
                    ? _buildPhoneInput()
                    : _buildPasswordInput(),
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: _isButtonEnabled
                    ? () {
                  if (_isPhoneStage) {
                    setState(() => _isPhoneStage = false);
                  } else {
                    _onSignUp(); // 회원가입 요청
                  }
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isButtonEnabled
                      ? Colors.orangeAccent
                      : Colors.grey,
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
