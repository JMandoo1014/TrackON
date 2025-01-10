import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:trackon/home/first_page.dart';

import 'package:trackon/main/location_page.dart';
import 'package:trackon/main/photoUpload_page.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _phoneNumber;
  double? latitude;
  double? longitude;
  List<String>? photoPath = [];
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadPhoneNumber();
    _loadUsername();
  }

  // 전화번호 가져오기
  Future<void> _loadPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _phoneNumber = prefs.getString('phonenumber'); // 로그인 시 저장된 전화번호
    });
  }

  // 사용자 이름 가져오기
  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '사용자';
    });
  }

  // 제보 전송
  Future<void> _submitReport() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    latitude = prefs.getDouble('latitude');
    longitude = prefs.getDouble('longitude');
    photoPath = prefs.getStringList('photoPaths');

    if (latitude == null || longitude == null || photoPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("위치와 사진 정보를 모두 입력해주세요.")),
      );
      return;
    }

    if (_phoneNumber == null || _phoneNumber!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("전화번호가 유효하지 않습니다.")),
      );
      return;
    }

    final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());


    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://43.201.10.190:3000/upload'), // AWS Strain server ip
    );
    request.fields['latitude'] = latitude.toString();
    request.fields['longitude'] = longitude.toString();
    request.fields['timestamp'] = timestamp;
    request.fields['phonenumber'] = _phoneNumber!;

    // 여러 사진 파일 전송
    for (String path in photoPath!) {
      request.files.add(await http.MultipartFile.fromPath('file', path));
    }

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("제보가 성공적으로 제출되었습니다!")),
        );

        // 데이터 제출 후 초기화
        _clearSubmittedData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("제보 제출에 실패했습니다: $responseBody")),
        );
        print(responseBody);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("제보 제출에 실패했습니다.")),
      );
      print(e);
    }
  }

  // 데이터 초기화 함수
  Future<void> _clearSubmittedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('latitude');
    await prefs.remove('longitude');
    await prefs.remove('photoPath');

    setState(() {
      latitude = null;
      longitude = null;
      photoPath = null;
    });

    // 정보가 제출된 후 화면 업데이트
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("모든 정보가 초기화되었습니다.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TrackON'),
        actions: [
          IconButton(
            onPressed: () async {
              bool? confirmLogout = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      '정말 로그아웃 하시겠습니까?',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('로그아웃'),
                      ),
                    ],
                  );
                },
              );
              if (confirmLogout == true) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => FirstPage()), // 로그아웃 후 첫 화면으로
                );
              }
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: SafeArea(
        top: true,
        child: Align(
          alignment: AlignmentDirectional(0, -0.6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Color(0xFFC3C3C3),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  width: 350,
                  height: 150,
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      text: '$username',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' 님 \n안녕하세요!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LocationPage()), // 위치 페이지
                      );
                    },
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: Color(0xFFE7D7AB),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Container(
                        width: 170,
                        height: 50,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '내 위치 찍기',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PhotoUploadPage()), // 사진 업로드 페이지
                      );
                    },
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: Color(0xFFE7D7AB),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Container(
                        width: 170,
                        height: 50,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '사진 업로드',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: _submitReport,
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: Colors.lightGreen,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Container(
                    width: 350,
                    height: 50,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '제보하기',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
