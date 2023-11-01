import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends GetxController {
  final storage = FirebaseStorage.instance;
  final picker = ImagePicker();
  RxString selectedValue = "10th".obs;
  RxBool isloading = false.obs;
  RxString uploadedimageUrl = "".obs;
  RxString selectedImageUrl = ''.obs;
  Rx<File> selectdImageFile = File('').obs;

  Future<void> uploadImage(String path) async {
    final reference = storage.ref().child('images/feed/$path');
    await reference.putFile(selectdImageFile.value);
    final downloadURL = await reference.getDownloadURL();
    uploadedimageUrl.value = downloadURL;
  }

  Future imagePicker() async {
    try {
      final imagePicker =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imagePicker == null) {
        return;
      }
      final imageTemp = File(imagePicker.path);
      selectedImageUrl.value = imagePicker.path;
      selectdImageFile.value = imageTemp;
    } on PlatformException {
      
      return 0 ;
    }
  }

  void updateSelectedValue(String value) {
    selectedValue.value = value;
  }
}

class ImageController2 extends GetxController {
  final storage = FirebaseStorage.instance;
  final picker = ImagePicker();
  RxString selectedValue = "10th".obs;
  RxBool isloading = false.obs;
  RxList<String> imageUrls = <String>[].obs;
  RxString uploadedimageUrl = "".obs;
  RxString selectedImageUrl = ''.obs;
  Rx<File> selectdImageFile = File('').obs;

  Future<void> uploadImage(String path) async {
    // final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final reference = storage.ref().child('images/feed/$path');
    await reference.putFile(selectdImageFile.value);
    final downloadURL = await reference.getDownloadURL();
    uploadedimageUrl.value = downloadURL;
  }

  Future imagePicker() async {
    try {
      final imagePicker =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (imagePicker == null) {
        return;
      }
      final imageTemp = File(imagePicker.path);
      selectedImageUrl.value = imagePicker.path;
      selectdImageFile.value = imageTemp;
    } on PlatformException {

      return 0;
    }
  }

  Future<void> downloadImages() async {
    final ListResult result = await storage.ref().child('images/feed').list();
    // ignore: avoid_function_literals_in_foreach_calls
    result.items.forEach((Reference reference) async {
      final downloadURL = await reference.getDownloadURL();
      imageUrls.add(downloadURL);
    });
  }

  void updateSelectedValue(String value) {
    selectedValue.value = value;
  }
}
