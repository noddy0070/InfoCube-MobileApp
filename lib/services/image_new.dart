import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fucare_android_studio/Pages/profile_edit.dart';
import 'package:fucare_android_studio/services/permissionhandler.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageControllerProfilePicture extends GetxController {
  final storage = FirebaseStorage.instance;
  final picker = ImagePicker();
  RxString uploadedimageUrl = "".obs;
  RxString selectedImageUrl = ''.obs;
  Rx<File> selectdImageFile = File('').obs;
  ProfileEditController profileEditController = Get.find();

  Future showImagePicker(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Card(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .3,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "Select Image From",
                      style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              permissionforImagePickerProfileGallery();
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.image,
                              size: 50,
                            ),
                          ),
                          const Text(
                            "Gallery",
                            style: TextStyle(fontFamily: "Inter", fontSize: 16),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              permissionforImagePickerProfileCamera();
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.camera,
                              size: 50,
                            ),
                          ),
                          const Text(
                            "Camera",
                            style: TextStyle(fontFamily: "Inter", fontSize: 16),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  imagefromgallery() async {
    await picker
        .pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
  }

  imagefromcamera() async {
    await picker
        .pickImage(source: ImageSource.camera, imageQuality: 50)
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
  }

  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.lightBlue,
            toolbarTitle: "Crop Image",
            statusBarColor: Colors.lightBlue.shade900,
            backgroundColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square));
    if (croppedFile != null) {
      selectedImageUrl.value = croppedFile.path;
      imageCache.clear();
      selectdImageFile.value = File(croppedFile.path);

      profileEditController.profileImageUrl.value = selectedImageUrl.value;
      if (selectedImageUrl.value.isNotEmpty) {
        profileEditController.cond2.value = true;
        profileEditController.selectedimage.value = selectdImageFile.value;
      }
    }
  }

  Future<void> uploadImage(String path) async {
    final reference = storage.ref().child('images/profilepicture/$path');
    await reference.putFile(profileEditController.selectedimage.value);
    final downloadURL = await reference.getDownloadURL();
    uploadedimageUrl.value = downloadURL;
  }
}

class ImageControllerPostPicture extends GetxController {
  final storage = FirebaseStorage.instance;
  final picker = ImagePicker();
  RxString selectedValue = "10th".obs;
  RxBool isloading = false.obs;
  RxString uploadedimageUrl = "".obs;
  RxString selectedImageUrl = ''.obs;
  Rx<File> selectdImageFile = File('').obs;
  RxInt height = 0.obs;
  RxInt width = 0.obs;

  Future showImagePicker(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Card(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .3,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "Select Image From",
                      style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              imagefromgallery();
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.image,
                              size: 50,
                            ),
                          ),
                          const Text(
                            "Gallery",
                            style: TextStyle(fontFamily: "Inter", fontSize: 16),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              imagefromcamera();
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.camera,
                              size: 50,
                            ),
                          ),
                          const Text(
                            "Camera",
                            style: TextStyle(fontFamily: "Inter", fontSize: 16),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  imagefromgallery() async {
    await picker
        .pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
  }

  imagefromcamera() async {
    await picker
        .pickImage(source: ImageSource.camera, imageQuality: 50)
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
  }

  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio16x9,
          CropAspectRatioPreset.ratio4x3,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.lightBlue,
            toolbarTitle: "Crop Image",
            statusBarColor: Colors.lightBlue.shade900,
            backgroundColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square));
    if (croppedFile != null) {
      imageCache.clear();
      var decodedImage =
          await decodeImageFromList(File(croppedFile.path).readAsBytesSync());
      width.value = decodedImage.width;
      height.value = decodedImage.height;
      selectdImageFile.value = File(croppedFile.path);
      selectedImageUrl.value = croppedFile.path;
    }
  }

  Future<void> uploadImage(String path) async {
    final reference = storage.ref().child('images/profilepicture/$path');
    await reference.putFile(selectdImageFile.value);
    final downloadURL = await reference.getDownloadURL();
    uploadedimageUrl.value = downloadURL;
  }

  void updateSelectedValue(String value) {
    selectedValue.value = value;
  }
}
