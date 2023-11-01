// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fucare_android_studio/Pages/navbar.dart';
import 'package:fucare_android_studio/Pages/profile_view.dart';
import 'package:fucare_android_studio/services/userpost_tile.dart';
import 'package:fucare_android_studio/widget/imageholder.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Userdetail userdetailcontroller = Get.find();
  ProfileViewController profileViewController =
      Get.put(ProfileViewController());
  String selectedOption = "Posts";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String field = '';
    for (int x = 0;
        x <
            userdetailcontroller
                .currentuser.value[0]["Field of Interest"].length;
        x++) {
      x == 0
          ? field =
              userdetailcontroller.currentuser.value[0]["Field of Interest"][x]
          : field += ' | ' +
              userdetailcontroller.currentuser.value[0]["Field of Interest"][x];
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .36,
              child: Stack(children: [
                Container(
                  color: const Color.fromARGB(255, 30, 130, 154),
                  height: MediaQuery.of(context).size.height * .07,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        Get.toNamed("/main/profile/settings");
                      },
                      icon: const Icon(
                        Icons.settings,
                        size: 40,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: userdetailcontroller.currentuser.value[0]
                                    ["ProfileUrl"] ==
                                "assets/images/defaultprofile.jpg"
                            ? const CircularImageWidget(
                                size: 70,
                                width: 4,
                                widthcolor: Color.fromARGB(255, 220, 229, 248),
                              )
                            : CircularImageWidget2(
                                size: 70,
                                width: 4,
                                widthcolor:
                                    const Color.fromARGB(255, 220, 229, 248),
                                imageurl: userdetailcontroller
                                    .currentuser.value[0]["ProfileUrl"],
                              ),
                      ),
                      Text(
                        userdetailcontroller.currentuser.value[0]
                                ["First Name"] +
                            " " +
                            userdetailcontroller.currentuser.value[0]
                                ['Last Name'],
                        style: const TextStyle(
                            fontFamily: "Inter",
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .005,
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
                        height: MediaQuery.of(context).size.height * .01,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .8,
                        height: MediaQuery.of(context).size.height * .08,
                        child: Text(
                          userdetailcontroller.currentuser.value[0]["Bio"],
                          maxLines: 3,
                          style: const TextStyle(
                              fontFamily: "Inter",
                              fontSize: 15,
                              overflow: TextOverflow.ellipsis,
                              color: Color.fromARGB(255, 10, 10, 10)),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .01,
                      ),
                      Column(
                        children: [
                          userdetailcontroller.currentuser.value[0]
                                      ["LinkedIn Url"] ==
                                  null
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
                                      width: MediaQuery.of(context).size.width *
                                          .65,
                                      child: Linkify(
                                        onOpen: onOpen,
                                        text: " - " +
                                            userdetailcontroller.currentuser
                                                .value[0]["LinkedIn Url"],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                        linkStyle: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.blue,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .01,
                          ),
                          userdetailcontroller.currentuser.value[0]
                                      ["Portfolio Url"] ==
                                  ""
                              ? Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .76,
                                    ),
                                    Text(
                                        "${userdetailcontroller.currentuser.value[0]["Followers"]} Followers")
                                  ],
                                )
                              : Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .65,
                                            child: Linkify(
                                              onOpen: onOpen,
                                              text:
                                                  "- ${userdetailcontroller.currentuser.value[0]["Portfolio Url"]}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              linkStyle: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.blue,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .01,
                                    ),
                                    Text(
                                        "${userdetailcontroller.currentuser.value[0]["Followers"].length} Follwers")
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
                child: Stack(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedOption = "Posts";
                          });
                        },
                        child: const Text(
                          "Posts",
                          style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedOption = "Saved";
                          });
                        },
                        child: const Text(
                          "Saved",
                          style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ])),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: selectedOption == "Posts"
                  ? Obx(() {
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
                                      typeofpost: "UserProfilePost",
                                      index: index,
                                    ));
                              });
                    })
                  : const Center(child: Text("Saved posts will be shown here")),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onOpen(LinkableElement link) async {
    Uri uri = Uri.parse(link.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
