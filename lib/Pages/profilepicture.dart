import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fucare_android_studio/Pages/signup.dart';
import 'package:fucare_android_studio/widget/buttons.dart';
import 'package:fucare_android_studio/widget/imageholder.dart';
import 'package:fucare_android_studio/widget/title_main.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final profileimageurl = "assets/images/defaultprofile.jpg".obs;
}

class ProfilePicturePage extends StatefulWidget {
  const ProfilePicturePage({super.key});

  @override
  State<ProfilePicturePage> createState() => _ProfilePicturePageState();
}

class _ProfilePicturePageState extends State<ProfilePicturePage> {
  bool selected = true;
  bool isUploading = false;

  ProfileController profileController = Get.put(ProfileController());

  SignupFormController signupFormController = Get.find();
  // Code to select and upload image
  final storage = FirebaseStorage.instance;
  File? imageFileMain;
  String? imageFilePath;
  String? uploadedimageUrl;

  showImagePicker(BuildContext context) async {
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
                              _imagefromgallery();
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
                              _imagefromcamera();
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

  final picker = ImagePicker();
  _imagefromgallery() async {
    await picker
        .pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
  }

  _imagefromcamera() async {
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
      imageCache.clear();
      setState(() {
        imageFileMain = File(croppedFile.path);
        imageFilePath = croppedFile.path;
      });
    }
  }

  Future<void> uploadImage(String path) async {
    final reference = storage.ref().child('images/profilepicture/$path');
    await reference.putFile(imageFileMain!);
    final downloadURL = await reference.getDownloadURL();
    setState(() {
      uploadedimageUrl = downloadURL;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 220, 229, 248),
        body: SingleChildScrollView(
          child: Stack(children: [
            Container(
              // Background image //
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/forgotpasswordBox.png'),
                      fit: BoxFit.fill)),
              height: screenHeight,
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * .1),
              child: const TitleMain(
                color: Color.fromARGB(255, 15, 121, 147),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * .28),
              child: const Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Choose Profile Picture",
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: 'AbhayaLibre',
                    color: Color.fromARGB(255, 30, 30, 30),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * .36),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selected = true;
                          });
                        },
                        child: CircularImageWidget(
                          width: selected ? 2 : 1,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Default",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showImagePicker(context);

                            selected = false;
                          });
                        },
                        child: imageFilePath == null
                            ? CircularImageWidget(
                                width: selected ? 1 : 2,
                                imageurl: "assets/images/customprofile.png",
                              )
                            : Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 6, 6, 6), // Border color
                                    width: selected ? 1 : 3, // Border width
                                  ),
                                ),
                                child: ClipOval(
                                  child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: AspectRatio(
                                      aspectRatio: 1 / 1,
                                      child: Image.file(imageFileMain!,
                                          fit: BoxFit.fitWidth),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Custom",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: screenHeight * .57),
                child: isUploading
                    ? const CircularProgressIndicator()
                    : MainBtn(
                        width: MediaQuery.of(context).size.width * .7,
                        fnc: () {
                          setState(() {
                            isUploading = true;
                          });

                          String path = signupFormController
                              .signupController.email.value.text
                              .toString();
                          uploadImage(path).whenComplete(() {
                            if (selected) {
                              profileController.profileimageurl.value =
                                  "assets/images/defaultprofile.jpg";
                            } else {
                              profileController.profileimageurl.value =
                                  uploadedimageUrl!;
                            }
                            Get.toNamed(
                                '/signup/signup2/verification/profilepicture/goal');
                            setState(() {
                              isUploading = false;
                            });
                          });
                        },
                        title: "Next",
                      ),
              ),
            )
          ]),
        ));
  }
}
