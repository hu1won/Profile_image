import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class ProfileIMG extends StatefulWidget {
  const ProfileIMG({Key? key}) : super(key: key);

  @override
  State<ProfileIMG> createState() => _ProfileIMGState();
}

class _ProfileIMGState extends State<ProfileIMG> {
  String? _pickedFile;

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width / 2;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF03050F),
        body: Column(
          children: [
            SizedBox(
              height: 150,
            ),
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 30.0,
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  WavyAnimatedText('프로필 이미지 수정'),
                ],
                isRepeatingAnimation: true,
              ),
            ),
            SizedBox(
              height: 60,
            ),
            if (_pickedFile == null)
              Container(
                constraints: BoxConstraints(
                  minHeight: imageSize,
                  minWidth: imageSize,
                ),
                child: GestureDetector(
                  onTap: () {
                    showBottomSheet();
                  },
                  child: Center(
                    child: Icon(
                      Icons.account_circle,
                      size: imageSize,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
              )
            else
              Center(
                child: Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 2, color: Theme.of(context).colorScheme.primary),
                    image: DecorationImage(
                        image: FileImage(File(_pickedFile!)),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            SizedBox(
              height: 60,
            ),
            Center(
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    FadeAnimatedText('프로필 이미지 변경을 원하시면'),
                    FadeAnimatedText('위 이미지를 클릭하세요.'),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  showBottomSheet() {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  '프로필 이미지',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt),
                const SizedBox(
                  width: 10,
                ),
                TextButton(
                  onPressed: () => getCameraImage(),
                  child: const Text('지금 촬영하기',
                      style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            const Divider(
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo),
                const SizedBox(
                  width: 10,
                ),
                TextButton(
                  onPressed: () => getPhotoLibraryImage(),
                  child: const Text('갤러리에서 불러오기',
                      style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }

  getCameraImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      await cropImage(pickedFile);
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  getPhotoLibraryImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await cropImage(pickedFile);
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  Future<void> cropImage(XFile? filePath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: filePath!.path,
      maxWidth: 1080,
      maxHeight: 1080,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: '프로필 이미지 편집',
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: '프로필 이미지 편집',
        )
      ],
    );
    if (croppedFile != null) {
      setState(() {
        _pickedFile = croppedFile.path;
      });
    }
  }
}
