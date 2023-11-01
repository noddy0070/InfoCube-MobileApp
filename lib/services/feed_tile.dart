// ignore_for_file: invalid_use_of_protected_member

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fucare_android_studio/Pages/navbar.dart';
import 'package:fucare_android_studio/Pages/profile_view.dart';
import 'package:fucare_android_studio/widget/imageholder.dart';
import 'package:fucare_android_studio/widget/post_bottomfnc.dart';
import 'package:get/get.dart';

class FeedTile extends StatelessWidget {
  final int index;
  final Userdetail userdetailcontroller = Get.find();

  FeedTile({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    dynamic currentpost = [];
    if (userdetailcontroller.feedlist.value.isEmpty) {
      return const Text("data");
    }
    try {
      currentpost = userdetailcontroller.feedlist.value[index];
    } catch (e) {
      currentpost = userdetailcontroller.feedlist.value[index - 1];
    }

    dynamic currentuser = userdetailcontroller.currentuser.value;
    bool infoi = false;

    if (currentuser[0]['Field of Interest'].contains(currentpost["Tag"])) {
      infoi = true;
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
    dynamic postuser;
    for (int x = 0; x < userdetailcontroller.userdatalist.value.length; x++) {
      if (userdetailcontroller.userdatalist.value[x]["Email"] ==
          currentpost["Email"]) {
        postuser = userdetailcontroller.userdatalist.value[x];
      }
    }

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
    if (postuser != null) {
      for (int x = 0; x < postuser["Field of Interest"].length; x++) {
        x == 0
            ? field = postuser["Field of Interest"][x]
            : field += " | ${postuser["Field of Interest"][x]}";
      }
    }

    return userdetailcontroller.islaoding.value && postuser!=null
        ? const CircularProgressIndicator()
        : infoi
            ? Container(
                height: 160 + heightmessage + heightpost,
                padding:
                    const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
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
                          GestureDetector(
                            onTap: () {
                              userdetailcontroller.postEmail.value =
                                  currentpost["Email"].toString().trim();
                              userdetailcontroller.pageselected.value =
                                  "ProfileView";
                              try {
                                ProfileViewController profileViewController =
                                    Get.find();
                                profileViewController
                                    .isfollowingchecker()
                                    .whenComplete(() {
                                  profileViewController.fetchProfileUser();
                                });
                              } catch (e) {
                                ProfileViewController profileViewController =
                                    Get.put(ProfileViewController());
                                profileViewController
                                    .isfollowingchecker()
                                    .whenComplete(() {
                                  profileViewController.fetchProfileUser();
                                });
                              }
                            },
                            child: Row(
                              children: [
                                postuser["ProfileUrl"] ==
                                        "assets/images/defaultprofile.jpg"
                                    ? const CircularImageWidget(
                                        width: 2,
                                        size: 40,
                                      )
                                    : CircularImageWidget2(
                                        imageurl: postuser["ProfileUrl"],
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
                                          "${postuser["First Name"]} ${postuser["Last Name"]}",
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
                                                overflow: TextOverflow.ellipsis,
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
                          ),
                        ],
                      ),
                    ),
                    ///// Main Container that Message shows profile pic name and field-------------------------------------------
                    currentpost["Message"].toString().trim() == ""
                        ? Container()
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              color: const Color.fromARGB(255, 131, 131, 131),
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
                ))
            : Container();
  }
}
