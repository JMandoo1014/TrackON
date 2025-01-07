import 'package:flutter/material.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final PageController _pageController = PageController();  // 페이지 컨트롤러

  bool _isPhoneEntered = false;  // 전화번호 입력 여부 상태 변수
  bool _isPasswordEntered = false;  // 비밀번호 입력 여부 상태 변수
  bool _isPasswordVisible = false;  // 비밀번호 보이기 여부 상태 변수

  // 비밀번호 입력란에 포커스를 맞추기 위한 FocusNode
  final FocusNode _passwordFocusNode = FocusNode();

  // 전화번호 입력 후 넘어가기 버튼을 눌렀을 때 상태 변경
  void _onPhoneNext() {
    if (_phoneController.text.isNotEmpty) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,  // 애니메이션 효과
      );
      // 전화번호 페이지를 넘어가면서 비밀번호 입력란으로 포커스를 이동
      FocusScope.of(context).requestFocus(_passwordFocusNode);
    }
  }

  // 비밀번호 입력 후 로그인 처리
  void _onLogin() {
    String phone = _phoneController.text;
    String password = _passwordController.text;
    if (phone.isNotEmpty && password.isNotEmpty) {
      // 로그인 처리 로직
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage())
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("로그인 성공!")),
      );
    } else {
      // 오류 메시지 출력
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("전화번호와 비밀번호를 입력해주세요")),
      );
    }
  }

  @override
  void dispose() {
    // FocusNode를 dispose하여 메모리 해제
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE7D7AB),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 50)),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),  // 스와이프 비활성화
              children: [
                // 전화번호 입력 페이지
                Container(
                  padding: EdgeInsets.all(40.0),
                  color: Colors.transparent,  // 배경을 투명으로 설정
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),  // 애니메이션 지속 시간
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
                          onChanged: (text) {
                            setState(() {
                              // 전화번호가 변경될 때마다 버튼 활성화 상태를 업데이트
                              _isPhoneEntered = text.isNotEmpty;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 40.0),
                      // "넘어가기" 버튼을 별도로 배치
                      ElevatedButton(
                        onPressed: _isPhoneEntered ? _onPhoneNext : null,  // 전화번호 입력이 있을 때만 활성화
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isPhoneEntered ? Colors.orangeAccent : Colors.grey,  // 입력이 없으면 회색
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),  // 모서리 둥글게
                          ),
                          minimumSize: Size(60, 60),  // 버튼을 정사각형으로 만듬
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
                // 비밀번호 입력 페이지
                Container(
                  padding: EdgeInsets.all(40.0),
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),  // 애니메이션 지속 시간
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
                          focusNode: _passwordFocusNode,  // 포커스를 지정
                          decoration: InputDecoration(
                            labelText: '비밀번호',
                            suffixIcon: IconButton(  // 눈 모양 아이콘 추가
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;  // 비밀번호 보이기/숨기기 토글
                                });
                              },
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: !_isPasswordVisible,  // 비밀번호를 보이게/숨기게 설정
                          onChanged: (text) {
                            setState(() {
                              // 비밀번호가 변경될 때마다 버튼 활성화 상태를 업데이트
                              _isPasswordEntered = text.isNotEmpty;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 40.0),
                      ElevatedButton(
                        onPressed: _isPasswordEntered ? _onLogin : null,  // 비밀번호 입력이 있을 때만 로그인 가능
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isPasswordEntered ? Colors.orangeAccent : Colors.grey,  // 입력이 없으면 회색
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),  // 모서리 둥글게
                          ),
                          minimumSize: Size(60, 60),  // 버튼을 정사각형으로 만듬
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}