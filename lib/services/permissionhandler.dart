import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fucare_android_studio/services/image_new.dart';
import 'package:permission_handler/permission_handler.dart';

permissionforImagePickerProfileCamera() async {
  PermissionStatus status = await Permission.camera.request();
  if (status.isGranted) {
    ImageControllerProfilePicture().imagefromcamera();
  }
}

permissionforImagePickerProfileGallery() async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt <= 32) {
      /// use [Permissions.storage.status]
      PermissionStatus status = await Permission.storage.request();
      if (status.isGranted) {
        ImageControllerProfilePicture().imagefromgallery();
      } else {}
    } else {
      /// use [Permissions.photos.status]
      PermissionStatus status = await Permission.photos.request();
      if (status.isGranted) {
        ImageControllerProfilePicture().imagefromgallery();
      } else {}
    }
  }
}

permissionforImagePickerPostCamera() async {
  PermissionStatus status = await Permission.camera.request();
  if (status.isGranted) {
    ImageControllerPostPicture().imagefromcamera();
  }
}

permissionforImagePickerPostGallery() async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt <= 32) {
      /// use [Permissions.storage.status]
      PermissionStatus status = await Permission.storage.request();
      if (status.isGranted) {
        ImageControllerPostPicture().imagefromgallery();
      } else {}
    } else {
      /// use [Permissions.photos.status]
      PermissionStatus status = await Permission.photos.request();
      if (status.isGranted) {
        ImageControllerPostPicture().imagefromgallery();
      } else {}
    }
  }
}
