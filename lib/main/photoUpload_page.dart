import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotoUploadPage extends StatefulWidget {
  @override
  State<PhotoUploadPage> createState() => _PhotoUploadPageState();
}

class _PhotoUploadPageState extends State<PhotoUploadPage> {
  List<XFile> _images = [];

  @override
  void initState() {
    super.initState();
    _loadSavedPhotos();
  }

  // 저장된 사진 경로 불러오기
  Future<void> _loadSavedPhotos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? photoPaths = prefs.getStringList('photoPaths');
    setState(() {
      if (photoPaths != null) {
        _images = photoPaths
            .where((path) => File(path).existsSync()) // 유효한 경로만 추가
            .map((path) => XFile(path))
            .toList();
        } else {
        _images = [];
      }
    });
  }

  // 갤러리에서 사진 선택
  Future<void> _pickImagesFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null && images.isNotEmpty) {
      setState(() {
        // 중복 방지
        _images.addAll(images.where((image) =>
        !_images.any((existingImage) => existingImage.path == image.path)));
      });
    }
  }

  // 카메라로 사진 촬영
  Future<void> _takePhotoWithCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        if (!_images.any((existingImage) => existingImage.path == image.path)) {
          _images.add(image);
        }
      });
    }
  }

  // 사진 저장
  Future<void> _savePhotos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> photoPaths = _images.map((image) => image.path).toList();
    await prefs.setStringList('photoPaths', photoPaths);
    print(photoPaths);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("사진이 저장되었습니다.")),
    );
  }

  // 공통 카드 스타일 생성
  Widget _buildCardButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Color(0xFFE7D7AB),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          width: 170,
          height: 50,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("사진 제출하기")),
      body: Column(
        children: [
          Expanded(
            child: _images.isEmpty
                ? Center(child: Text("사진이 선택되지 않았습니다."))
                : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Image.file(
                      File(_images[index].path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      right: -5,
                      top: -5,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _images.removeAt(index);
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCardButton('사진 가져오기', _pickImagesFromGallery),
              _buildCardButton('사진 찍기', _takePhotoWithCamera),
            ],
          ),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: _savePhotos,
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: Colors.lightGreen,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                width: 350,
                height: 50,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '저장하기',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
