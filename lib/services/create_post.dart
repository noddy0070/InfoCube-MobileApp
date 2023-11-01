import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fucare_android_studio/Pages/navbar.dart';
import 'package:fucare_android_studio/services/image.dart';
import 'package:fucare_android_studio/services/image_new.dart';
import 'package:fucare_android_studio/services/uniqueid.dart';
import 'package:fucare_android_studio/services/userdata.dart';
import 'package:fucare_android_studio/services/userdataformat.dart';
import 'package:fucare_android_studio/widget/buttons.dart';
import 'package:fucare_android_studio/widget/imageholder.dart';
import 'package:get/get.dart';

class Dialogbox {
  ImageControllerPostPicture imageControllerPostPicture =
      Get.put(ImageControllerPostPicture());
  TextEditingController controller = TextEditingController();
  Userdetail userdetailcontroller = Get.find();
  void showBottomDialog(
      BuildContext context, String username, String userprofession) {
    imageControllerPostPicture.updateSelectedValue(
        userdetailcontroller.currentuser.value[0]['Field of Interest'][0]);
    showDialog(
      context: context,
      barrierDismissible:
          true, // Allows tapping outside the dialog to close it.
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white.withOpacity(0),
          // Set a shape with rounded corners.
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60.0),
          ),
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0),
              ),
              height: MediaQuery.of(context).size.height * .7,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 231, 238, 255),
                        border: Border.all(color: Colors.black, width: 3),
                        borderRadius: BorderRadius.circular(
                            40)), // Adjust the border radius
                    height: MediaQuery.of(context).size.height * .6,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              userdetailcontroller.currentuser.value[0]
                                          ["ProfileUrl"] ==
                                      "assets/images/defaultprofile.jpg"
                                  ? const CircularImageWidget(
                                      size: 60,
                                    )
                                  : CircularImageWidget2(
                                      size: 60,
                                      imageurl: userdetailcontroller
                                          .currentuser.value[0]["ProfileUrl"],
                                    ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    username,
                                    style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .6,
                                    child: Text(
                                      style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                      userprofession,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.attach_file),
                              onPressed: () {
                                imageControllerPostPicture
                                    .showImagePicker(context);
                              },
                            ),
                            const Text('Attach File',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)),
                            Obx(() {
                              final selectedvalue = imageControllerPostPicture
                                  .selectedValue.value;
                              return Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      border: Border.all(width: 1)),
                                  width:
                                      MediaQuery.of(context).size.width * .42,
                                  child: DropdownButton<String>(
                                    value: selectedvalue,
                                    underline: Container(
                                      height: 0,
                                      color: Colors.black, // Remove underline
                                    ),
                                    dropdownColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 18,
                                    focusColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    borderRadius: BorderRadius.circular(20),
                                    iconDisabledColor: Colors.black,
                                    onChanged: (newValue) {
                                      imageControllerPostPicture
                                          .selectedValue.value = newValue!;
                                    },
                                    items: <String>[
                                      for (int x = 0;
                                          x <
                                              userdetailcontroller
                                                  .currentuser
                                                  .value[0]['Field of Interest']
                                                  .length;
                                          x++)
                                        userdetailcontroller.currentuser
                                            .value[0]['Field of Interest'][x]
                                            .toString()
                                    ]
                                        .map<DropdownMenuItem<String>>(
                                          (String value) =>
                                              DropdownMenuItem<String>(
                                            value: value,
                                            child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .35,
                                                child: Text(value)),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                        Obx(
                          () {
                            final selectedImageUrl = imageControllerPostPicture
                                .selectedImageUrl.value;
                            return selectedImageUrl.isEmpty
                                ? Container()
                                : imageControllerPostPicture.isloading.value
                                    ? Stack(
                                        alignment: Alignment.center,
                                        children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255),
                                                      border:
                                                          Border.all(width: 1)),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .8,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .25,
                                                  child: AspectRatio(
                                                    aspectRatio: 1 / 1,
                                                    child: Image.file(
                                                        imageControllerPostPicture
                                                            .selectdImageFile
                                                            .value,
                                                        fit: BoxFit.fitWidth),
                                                  )),
                                            ),
                                            const Center(
                                                child:
                                                    CircularProgressIndicator())
                                          ])
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 255, 255, 255),
                                                border: Border.all(width: 1)),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .8,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .25,
                                            child: AspectRatio(
                                              aspectRatio: 1 / 1,
                                              child: Image.file(
                                                  imageControllerPostPicture
                                                      .selectdImageFile.value,
                                                  fit: BoxFit.fitWidth),
                                            )),
                                      );
                          },
                        ),
                        Obx(() {
                          final selectedImageUrl =
                              imageControllerPostPicture.selectedImageUrl.value;
                          return Container(
                            height: selectedImageUrl.isEmpty
                                ? MediaQuery.of(context).size.height * .38
                                : MediaQuery.of(context).size.height * .1,
                            width: MediaQuery.of(context).size.width * .8,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 40, 40, 40),
                                    width: 2),
                                borderRadius: BorderRadius.circular(20)),
                            child: TextField(
                              controller: controller,
                              expands: false,
                              style: const TextStyle(
                                  fontSize: 20.0, color: Colors.black54),
                              maxLines: 11,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 40, 40, 40)),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 40, 40, 40)),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                contentPadding: const EdgeInsets.all(12.0),
                                hintText: "Write Something...",
                                alignLabelWithHint: true,
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MainBtn(
                      width: 200,
                      fnc: () async {
                        String first = userdetailcontroller.currentuser.value[0]
                            ['First Name'];
                        String last = userdetailcontroller.currentuser.value[0]
                            ['Last Name'];
                        DateTime now = DateTime.now();
                        String uid = uidGenerator(
                            userdetailcontroller.currentuser.value[0]['Email'],
                            "Post",
                            now);
                        String path =
                            imageControllerPostPicture.selectedValue.value +
                                username +
                                now.toString();
                        imageControllerPostPicture.isloading.value = true;
                        imageControllerPostPicture
                            .uploadImage(path)
                            .whenComplete(() async {
                          username =
                              "${first[0].toUpperCase()}${first.substring(1)} ${last[0].toUpperCase()}${last.substring(1)}";
                          // all the values that will be stored in a post
                          final postData = PostData(
                            uid: uid,
                            senderemail: userdetailcontroller
                                .currentuser.value[0]['Email'],
                            currentdatetime: now,
                            message: controller.text,
                            imagepath: imageControllerPostPicture
                                .uploadedimageUrl.value,
                            tag: imageControllerPostPicture.selectedValue.value
                                .toString(),
                            height: imageControllerPostPicture.height.value,
                            width: imageControllerPostPicture.width.value,
                          );
                          if (postData.message == '' &&
                              postData.imagepath == '') {
                            Get.snackbar("Enter something in the post", "");
                          } else {
                            await Get.put(
                                    SendPostData(context).sendPost(postData))
                                .whenComplete(() async {
                              Stream<QuerySnapshot> user =
                                  DatabaseManager().getFeedItem();
                              userdetailcontroller.feed.value = user;
                              userdetailcontroller.length2.value =
                                  userdetailcontroller.feedlist.value.length;
                              Get.delete<ImageController>();
                              imageControllerPostPicture.isloading.value =
                                  false;
                              Navigator.pop(context);
                            });
                          }
                        });
                      },
                      title: "Post")
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CreatePost extends StatefulWidget {
  final BuildContext context;
  const CreatePost({super.key, required this.context});
  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // String userEmail = '';
  // List userdatalist = [''];
  List currentuser = [];
  String userprofession = '';
  String first = '';
  String last = '';
  String username = '';
  Userdetail userdetailcontroller = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: 20,
      child: Material(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: const Color.fromARGB(255, 30, 150, 154)),
            child: IconButton(
              color: const Color.fromARGB(255, 0, 0, 0),
              icon: const Icon(
                Icons.post_add,
                size: 35,
              ),
              onPressed: () async {
                currentuser = userdetailcontroller.currentuser.value;

                String first = currentuser[0]['First Name'];
                String last = currentuser[0]['Last Name'];
                username = "$first $last";
                List profession = currentuser[0]['Field of Interest'];
                for (int x = 0; x < profession.length; x++) {
                  if (x == profession.length - 1) {
                    "$userprofession, ${profession[x]}";
                  } else if (x == 0) {
                    userprofession = profession[0];
                  } else {
                    "$userprofession, ${profession[x]}";
                  }
                }
                Dialogbox().showBottomDialog(context, username, userprofession);
              },
            )),
      ),
    );
  }
}
