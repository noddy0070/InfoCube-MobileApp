// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:fucare_android_studio/widget/buttons.dart';
import 'package:fucare_android_studio/widget/value_field.dart';
import 'package:image_picker/image_picker.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';

class Experiment extends StatefulWidget {
  const Experiment({super.key});

  @override
  State<Experiment> createState() => _ExperimentState();
}

class _ExperimentState extends State<Experiment> {
 
  File? imageFileMain;

  void showImagePicker(BuildContext context) {
    showBottomSheet(
        context: context,
        builder: (builder) {
          return Card(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .2,
              child: Column(
                children: [
                  const Text("Select Image"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            _imagefromgallery();
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.image,
                            size: 50,
                          )),
                      ElevatedButton(
                          onPressed: () {
                            _imagefromcamera();
                            Navigator.pop(context);
                          },
                          child:const  Icon(
                            Icons.camera,
                            size: 50,
                          )),
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
          CropAspectRatioPreset.ratio16x9,
          CropAspectRatioPreset.original
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.lightBlue,
            toolbarTitle: "Crop Image",
            statusBarColor: Colors.lightBlue.shade900,
            backgroundColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square));
    if (croppedFile != null) {
      imageCache.clear();
      // var decodedImage =
      //     await decodeImageFromList(File(croppedFile.path).readAsBytesSync());
      setState(() {
        // print(decodedImage.width);
        // print(decodedImage.height);
        // print("aspectratio: ${decodedImage.width / decodedImage.height}");
        imageFileMain = File(croppedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text("Hello"),
          MainBtn(
            width: 120,
            fnc: () {
              // Call to pick an image
            
            },
            title: "Pick Image",
          ),
          MainBtn(
            width: 120,
            fnc: () {
              // Call to upload the selected image
            },
            title: "Upload Image",
          ),
          Center(
            child: ValueField(
              controller: TextEditingController(),
              labeltext: "Hello",
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          imageFileMain == null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(150),
                  child: Image.asset(
                    "assets/images/defaultprofile.jpg",
                    height: 200,
                    width: 200,
                    fit: BoxFit.fill,
                  ),
                )
              : Column(
                  children: [
                    Container(
                      color: Colors.amber,
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.file(
                          imageFileMain!,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                  ],
                ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () async {
                if (Platform.isAndroid) {
                  final androidInfo = await DeviceInfoPlugin().androidInfo;
                  if (androidInfo.version.sdkInt <= 32) {
                    /// use [Permissions.storage.status]
                    Map<Permission, PermissionStatus> statuses =
                        await [Permission.camera, Permission.storage].request();
                    if (statuses[Permission.camera]!.isGranted &&
                        statuses[Permission.storage]!.isGranted) {
                      showImagePicker(context);
                    } else {
                      // print("No permission granted android sdk less than 32");
                    }
                  } else {
                    /// use [Permissions.photos.status]
                    Map<Permission, PermissionStatus> statuses =
                        await [Permission.camera, Permission.photos].request();
                    if (statuses[Permission.camera]!.isGranted &&
                        statuses[Permission.photos]!.isGranted) {
                      showImagePicker(context);
                    } else {
                      // print("No permission granted");
                    }
                  }
                }
              },
              child: const Text("TakeImage"))
        ],
      ),
    );
  }
}
