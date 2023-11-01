import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fucare_android_studio/Pages/navbar.dart';
import 'package:fucare_android_studio/Pages/profile_view.dart';
import 'package:fucare_android_studio/services/userdata.dart';
import 'package:fucare_android_studio/widget/imageholder.dart';
import 'package:fucare_android_studio/widget/post_bottomfnc.dart';
import 'package:get/get.dart';

class UserPostTile extends StatefulWidget {
  final int index;
  final String typeofpost;
  final String email;

 const UserPostTile(
      {super.key,
      required this.index,
      required this.typeofpost,
      this.email = "None"});

  @override
  State<UserPostTile> createState() => _UserPostTileState();
}

class _UserPostTileState extends State<UserPostTile> {
  final Userdetail userdetailcontroller = Get.find();
  final ProfileViewController profileViewController = Get.find();
  bool longPressCond = false;

  @override
  Widget build(BuildContext context) {
    dynamic currentpost = [];
    if (userdetailcontroller.feedlist.value.isEmpty) {
      return const Text("data");
    }
    try {
      currentpost = userdetailcontroller.feedlist.value[widget.index];
    } catch (e) {
      currentpost = userdetailcontroller.feedlist.value[widget.index - 1];
    }

    dynamic currentuser = userdetailcontroller.currentuser.value;
    bool infoi = false;
    if (widget.typeofpost == "OthersProfilePost") {
      if (widget.email == currentpost["Email"]) {
        infoi = true;
        currentuser = profileViewController.currentuser.value;
      }
    } else if (widget.typeofpost == "UserProfilePost") {
      if (currentuser[0]['Email'] == currentpost["Email"]) {
        currentuser = userdetailcontroller.currentuser.value;
        infoi = true;
      }
    }

    Timestamp firestoreTimestamp =
        currentpost["Date"]; // Replace with your Timestamp

    // Convert Firestore Timestamp to DateTime
    DateTime dateTime = firestoreTimestamp.toDate();
    // Extract date components
    Map<int, String> monthMap = {
      1: 'January',
      2: 'February',
      3: 'March',
      4: 'April',
      5: 'May',
      6: 'June',
      7: 'July',
      8: 'August',
      9: 'September',
      10: 'October',
      11: 'November',
      12: 'December'
    };
    int month = dateTime.month;
    int day = dateTime.day;
    String date = "${monthMap[month]} $day";

    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: currentpost["Message"].trim(),
        style: const TextStyle(
          fontFamily: 'Arial',
          fontSize: 17.0,
          fontWeight: FontWeight.w500,
        ), // You can adjust the font size as needed
      ),
      textDirection: TextDirection.ltr,
    )..layout(
        maxWidth: MediaQuery.of(context).size.width); // Set the maximum width

    // Add padding for better visualization
    double heightmessage = textPainter.height * 1.4;
    double heightpost = 0;
    double widthpost = MediaQuery.of(context).size.width;

    if (currentpost["Message"].toString().trim() == "") {
      heightmessage = 0;
    }
    if (currentpost["Imagepath"].toString().trim() == "") {
      heightpost = 0;
    } else {
      final getheight = currentpost['Height'];
      final getwidth = currentpost['Width'];
      heightpost = widthpost * getheight / getwidth;
    }
    String field = '';
    for (int x = 0; x < currentuser[0]["Field of Interest"].length; x++) {
      x == 0
          ? field = currentuser[0]["Field of Interest"][x]
          : field += " | ${currentuser[0]["Field of Interest"][x]}";
    }

    return userdetailcontroller.islaoding.value
        ? const CircularProgressIndicator()
        : infoi
            ? GestureDetector(
                onLongPressStart: (LongPressStartDetails details) {
                  setState(() {
                    longPressCond = true;
                  });
                },
                onLongPress: () async {
                  if (widget.typeofpost == "UserProfilePost") {
                    final cond =
                        await _showBottomSheet(context, currentpost["Uid"]);
                    if (cond == null) {
                      setState(() {
                        longPressCond = false;
                      });
                    }
                  }
                },
                onLongPressEnd: (LongPressEndDetails details) {
                  setState(() {
                    longPressCond = false;
                  });
                },
                child: Container(
                    height: 160 + heightmessage + heightpost,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0.0, vertical: 0),
                    margin: const EdgeInsets.only(
                      bottom: 5,
                    ),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        border: Border(
                            bottom: BorderSide(
                                width: 0,
                                color: Color.fromARGB(255, 255, 255, 255)))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          ///// Main row that shows profile pic name and field-------------------------------------------
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  currentuser[0]["ProfileUrl"] ==
                                          "assets/images/defaultprofile.jpg"
                                      ? const CircularImageWidget(
                                          width: 2,
                                          size: 40,
                                        )
                                      : CircularImageWidget2(
                                          imageurl: currentuser[0]
                                              ["ProfileUrl"],
                                          width: 1,
                                          size: 40,
                                        ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${currentuser[0]["First Name"]} ${currentuser[0]["Last Name"]}",
                                            style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .73,
                                            height: 30,
                                            child: Text(
                                              field,
                                              style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 12,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.clip,
                                              maxLines: 1,
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            // print("Hello");
                                          },
                                          child: const Icon(
                                            Icons.more_vert_rounded,
                                            size: 30,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        ///// Main Container that Message shows profile pic name and field-------------------------------------------
                        currentpost["Message"].toString().trim() == ""
                            ? Container()
                            : Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                height: heightmessage + 10,
                                child: Text(currentpost["Message"].trim(),
                                    style: const TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500)),
                              ),

                        // Image
                        currentpost["Imagepath"].toString().trim() == ""
                            ? Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  color:
                                      const Color.fromARGB(255, 131, 131, 131),
                                  child: CachedNetworkImage(
                                    imageUrl: currentpost["Imagepath"],
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                )),
                        // Like Comment Share and Shave
                        PostBottom(
                          date: date,
                          currentpost: currentpost,
                        )
                      ],
                    )),
              )
            : Container();
  }
}

Future _showBottomSheet(BuildContext context, String uid) async {
  final result = await showModalBottomSheet(
    showDragHandle: true,
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(
              Icons.delete,
              color: Color.fromARGB(198, 220, 1, 1),
            ),
            title: const Text(
              'Delete Post',
              style: TextStyle(fontFamily: "Inter", fontSize: 16),
            ),
            onTap: () {
              String postdocumentid = '';
              fetchMessageDocId() async {
                await FirebaseFirestore.instance
                    .collection("Feed")
                    .where("Uid", isEqualTo: uid)
                    .get()
                    .then((value) {
                  postdocumentid = value.docs[0].id;
                });
              }

              fetchMessageDocId().whenComplete(() {
                DeletePost(context)
                    .deleteMessage(postdocumentid)
                    .whenComplete(() {
                  // print("done");
                  Navigator.pop(context);
                });
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Post',
                style: TextStyle(fontFamily: "Inter", fontSize: 16)),
            onTap: () {
              // Handle action when 'Take a Picture' is tapped
              // ...
              Navigator.pop(context);
            },
          ),
          // Add more options as needed
        ],
      );
    },
  );
  // Handle the result returned from the bottom sheet (if any)
  return result;
}
