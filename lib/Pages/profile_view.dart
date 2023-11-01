// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fucare_android_studio/Pages/navbar.dart';
import 'package:fucare_android_studio/services/follow_unfollow.dart';
import 'package:fucare_android_studio/services/userdata.dart';
import 'package:fucare_android_studio/services/userpost_tile.dart';
import 'package:fucare_android_studio/widget/buttons.dart';
import 'package:fucare_android_studio/widget/imageholder.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileViewController extends GetxController {
  Rx<dynamic> currentuser = Rx<dynamic>(null);
  final Userdetail userdetailcontroller = Get.find();
  RxBool isfollowing = false.obs;
  RxString documentid = ''.obs;
  RxBool isloading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Call the asynchronous function when the controller is initialized
    fetchdocumentid().whenComplete(
      () {
        isfollowingchecker();
      },
    );
    fetchProfileUser();
  }

  Future<void> fetchdocumentid() async {
    documentid.value = await DatabaseManager()
        .getDocumentId(userdetailcontroller.currentuser.value[0]["Email"]);
  }

  Future<void> isfollowingchecker() async {
    bool cond = await DatabaseManager().isfollowingchecker(
        userdetailcontroller.postEmail.value, documentid.value);
    isfollowing.value = cond;
  }

  Future<void> fetchProfileUser() async {
    final user = await DatabaseManager()
        .getProfileUser(userdetailcontroller.postEmail.value);
    currentuser.value = user;
  }
}

class ProfileView extends StatefulWidget {
  final String email;
  const ProfileView({super.key, required this.email});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final Userdetail userdetailcontroller = Get.find();
  ProfileViewController profileViewController = Get.find();

  String selectedOption = "Posts";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isfollowing = profileViewController.isfollowing.value;
      bool isloading = profileViewController.isloading.value;
      dynamic profileuser = profileViewController.currentuser.value;
      String field = '';
      if (profileuser != null) {
        for (int x = 0; x < profileuser[0]["Field of Interest"].length; x++) {
          x == 0
              ? field = profileuser[0]["Field of Interest"][x]
              : field += ' | ' + profileuser[0]["Field of Interest"][x];
        }
      }
      return profileuser == null ||
              profileuser[0]["Email"] != userdetailcontroller.postEmail.value
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .36,
                      child: Stack(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              color: const Color.fromARGB(255, 30, 130, 154),
                              height: MediaQuery.of(context).size.height * .07,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: isloading
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              .1,
                                      width: MediaQuery.of(context).size.width *
                                          .3,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: const Color.fromARGB(
                                                    255, 76, 158, 235))),
                                        child: Center(
                                          child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .06,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .06,
                                              child:
                                                  const CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Color.fromARGB(
                                                    255, 76, 158, 235),
                                              )),
                                        ),
                                      ))
                                  : MainBtn(
                                      elevation: 0,
                                      color: const Color.fromARGB(
                                          255, 220, 229, 248),
                                      bordercolor: const Color.fromARGB(
                                          255, 76, 158, 235),
                                      height:
                                          MediaQuery.of(context).size.width *
                                              .1,
                                      width: MediaQuery.of(context).size.width *
                                          .3,
                                      textStyle: const TextStyle(
                                          fontSize: 16,
                                          color: Color.fromARGB(
                                              255, 76, 158, 235)),
                                      fnc: isfollowing
                                          ? () {
                                              unfollow(context);
                                            }
                                          : () {
                                              follow(context);
                                            },
                                      title:
                                          isfollowing ? "Unfollow" : "Follow",
                                    ),
                            )
                          ],
                        ),
                        //Image widget -----------------------------------------------------
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: profileuser[0]["ProfileUrl"] ==
                                        "assets/images/defaultprofile.jpg"
                                    ? const CircularImageWidget(
                                        size: 70,
                                        width: 4,
                                        widthcolor:
                                            Color.fromARGB(255, 220, 229, 248),
                                      )
                                    : CircularImageWidget2(
                                        size: 70,
                                        width: 4,
                                        widthcolor: const Color.fromARGB(
                                            255, 220, 229, 248),
                                        imageurl: profileuser[0]["ProfileUrl"],
                                      ),
                              ),
                              Text(
                                profileuser[0]["First Name"] +
                                    " " +
                                    profileuser[0]['Last Name'],
                                style: const TextStyle(
                                    fontFamily: "Inter",
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .005,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .8,
                                child: Text(
                                  field,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontFamily: "Inter",
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis,
                                      color: Color.fromARGB(255, 72, 72, 72)),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .01,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .8,
                                height:
                                    MediaQuery.of(context).size.height * .08,
                                child: Text(
                                  profileuser[0]["Bio"],
                                  maxLines: 3,
                                  style: const TextStyle(
                                      fontFamily: "Inter",
                                      fontSize: 15,
                                      overflow: TextOverflow.ellipsis,
                                      color: Color.fromARGB(255, 10, 10, 10)),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .01,
                              ),
                              Column(
                                children: [
                                  profileuser[0]["LinkedIn Url"] == null
                                      ? Container()
                                      : Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/linkedinLogo.png",
                                              width: 20.0,
                                              height: 20.0,
                                              fit: BoxFit.cover,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .65,
                                              child: Linkify(
                                                onOpen: _onOpen,
                                                text: " - " +
                                                    profileuser[0]
                                                        ["LinkedIn Url"],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0)),
                                                linkStyle: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.blue,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ),
                                          ],
                                        ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        .01,
                                  ),
                                  profileuser[0]["Portfolio Url"] == ""
                                      ? Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .76,
                                            ),
                                            Text(
                                                "${profileuser[0]["Followers"]} Followers")
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .75,
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/images/linkIcon.png",
                                                    width: 20.0,
                                                    height: 20.0,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .65,
                                                    child: Linkify(
                                                      onOpen: _onOpen,
                                                      text:
                                                          "- ${profileuser[0]["Portfolio Url"]}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 0, 0, 0),
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                      linkStyle: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.blue,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .01,
                                            ),
                                            Text(
                                                "${profileuser[0]["Followers"].length} Follwers")
                                          ],
                                        ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ]),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        color: const Color.fromARGB(255, 30, 130, 154),
                        height: MediaQuery.of(context).size.height * .06,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Updates",
                              style: TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        )),
                    SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Obx(() {
                          final len = userdetailcontroller.length2.value;
                          return userdetailcontroller.currentuser.value == null
                              ? const Center(
                                  child: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: CircularProgressIndicator()))
                              : ListView.builder(
                                  itemCount: len,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                        onTap: () {},
                                        child: UserPostTile(
                                          typeofpost: "OthersProfilePost",
                                          index: index,
                                          email: profileuser[0]["Email"],
                                        ));
                                  });
                        })),
                  ],
                ),
              ),
            );
    });
  }

  Future<void> _onOpen(LinkableElement link) async {
    Uri uri = Uri.parse(link.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
