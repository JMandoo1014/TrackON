import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationPage extends StatefulWidget {
  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String location = "위치 정보를 얻어오세요";

  @override
  void initState() {
    super.initState();
    _loadSavedLocation();
  }

  Future<void> _loadSavedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? latitude = prefs.getDouble('latitude');
    double? longitude = prefs.getDouble('longitude');

    if (latitude != null && longitude != null) {
      setState(() {
        location = "저장된 위치 - 위도: $latitude, 경도: $longitude";
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return setState(() => location = "위치 서비스가 비활성화되었습니다.");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return setState(() => location = "위치 권한이 거부되었습니다.");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return setState(() => location = "위치 권한이 영구적으로 거부되었습니다.");
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setDouble('latitude', position.latitude);
      prefs.setDouble('longitude', position.longitude);

      setState(() {
        location = "위도: ${position.latitude}, 경도: ${position.longitude}";
      });
    } catch (e) {
      setState(() {
        location = "위치 정보를 가져오는 중 오류가 발생했습니다: $e";
      });
    }
  }

  Future<void> _resetLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('latitude');
    await prefs.remove('longitude');

    setState(() {
      location = "위치 정보가 초기화되었습니다.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("내 위치 찍기")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              location,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: Text("위치 가져오기"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _resetLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text("위치 초기화"),
            ),
          ],
        ),
      ),
    );
  }
}
