import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fucare_android_studio/Pages/navbar.dart';
import 'package:fucare_android_studio/services/userdata.dart';
import 'package:get/get.dart';

class PostBottom extends StatefulWidget {
  final dynamic currentpost;
  final String date;
  const PostBottom({super.key, required this.currentpost, required this.date});

  @override
  State<PostBottom> createState() => _PostBottomState();
}

class _PostBottomState extends State<PostBottom> {
  Userdetail userdetailcontroller = Get.find();
  bool isLiked = false;
  bool isSaved = false;
  String postdocumentid = '';
  String userdocumentid = '';
  bool isloading = true;

  @override
  void initState() {
    super.initState();
    fetchdocumentid().whenComplete(() {
      setState(() {
        isloading = false;
      });
    });
  }

  Future fetchdocumentid() async {
    await FirebaseFirestore.instance
        .collection("Feed")
        .where("Uid", isEqualTo: widget.currentpost["Uid"])
        .get()
        .then((value) {
      postdocumentid = value.docs[0].id;
    });
    String id = await DatabaseManager()
        .getDocumentId(userdetailcontroller.currentuser.value[0]["Email"]);
    userdocumentid = id;
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width * .075;
    dynamic currentpost = widget.currentpost;
    if (userdetailcontroller.currentuser.value[0]["Liked"]
        .contains(currentpost["Uid"])) {
      isLiked = true;
    }
    if (userdetailcontroller.currentuser.value[0]["Saved"]
        .contains(currentpost["Uid"])) {
      isSaved = true;
    }
    return isloading
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: MediaQuery.of(context).size.width,
                  height: 30,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        width: size,
                        child: GestureDetector(
                          onTap: () {},
                          child: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_outline,
                            color: Colors.red,
                            size: size,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: size,
                        child: GestureDetector(
                          onTap: () {},
                          child: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_outline,
                            color: Colors.black,
                            size: size,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: size,
                        child: GestureDetector(
                          onTap: () {
                            _commentSection(context);
                          },
                          child: Icon(
                            Icons.comment_outlined,
                            color: Colors.black,
                            size: size,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      SizedBox(
                        width: size,
                        child: GestureDetector(
                          onTap: () {},
                          child: Icon(
                            Icons.share,
                            color: Colors.black,
                            size: size * .9,
                          ),
                        ),
                      ),
                    ],
                  )),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "${currentpost["Liked"].length} Likes",
                    ),
                    Expanded(
                        child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                    )),
                    Text(
                      widget.date,
                    ),
                  ],
                ),
              )
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: MediaQuery.of(context).size.width,
                  height: 30,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        width: size,
                        child: GestureDetector(
                          onTap: () {
                            List likedlistuser = userdetailcontroller
                                .currentuser.value[0]["Liked"];
                            List likedlistpost = currentpost["Liked"];

                            if (isLiked) {
                              setState(() {
                                isLiked = false;
                              });
                              likedlistuser.remove(currentpost["Uid"]);
                              likedlistpost.remove(userdetailcontroller
                                  .currentuser.value[0]["Email"]);
                              LikeUnlikePost(context)
                                  .likeUnlikePost(
                                      userdocumentid,
                                      postdocumentid,
                                      likedlistuser,
                                      likedlistpost)
                                  .whenComplete(() {
                                userdetailcontroller.fetchCurrentUser();
                              });
                            } else {
                              setState(() {
                                isLiked = true;
                              });
                              likedlistuser.add(currentpost["Uid"]);
                              likedlistpost.add(userdetailcontroller
                                  .currentuser.value[0]["Email"]);
                              LikeUnlikePost(context)
                                  .likeUnlikePost(
                                      userdocumentid,
                                      postdocumentid,
                                      likedlistuser,
                                      likedlistpost)
                                  .whenComplete(() =>
                                      userdetailcontroller.fetchCurrentUser());
                            }
                          },
                          child: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_outline,
                            color: Colors.red,
                            size: size,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: size,
                        child: GestureDetector(
                          onTap: () {
                            List savedlistuser = userdetailcontroller
                                .currentuser.value[0]["Saved"];
                            List savedlistpost = currentpost["Saved"];

                            if (isSaved) {
                              setState(() {
                                isSaved = false;
                              });
                              savedlistuser.remove(currentpost["Uid"]);
                              savedlistpost.remove(userdetailcontroller
                                  .currentuser.value[0]["Email"]);
                              SaveUnsavePost(context)
                                  .saveUnsavePost(
                                      userdocumentid,
                                      postdocumentid,
                                      savedlistuser,
                                      savedlistpost)
                                  .whenComplete(() =>
                                      userdetailcontroller.fetchCurrentUser());
                            } else {
                              setState(() {
                                isSaved = true;
                              });
                              savedlistuser.add(currentpost["Uid"]);
                              savedlistpost.add(userdetailcontroller
                                  .currentuser.value[0]["Email"]);
                              SaveUnsavePost(context)
                                  .saveUnsavePost(
                                      userdocumentid,
                                      postdocumentid,
                                      savedlistuser,
                                      savedlistpost)
                                  .whenComplete(() =>
                                      userdetailcontroller.fetchCurrentUser());
                            }
                          },
                          child: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_outline,
                            color: Colors.black,
                            size: size,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: size,
                        child: GestureDetector(
                          onTap: () {
                            _commentSection(context);
                          },
                          child: Icon(
                            Icons.comment_outlined,
                            color: Colors.black,
                            size: size,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      SizedBox(
                        width: size,
                        child: GestureDetector(
                          onTap: () {},
                          child: Icon(
                            Icons.share,
                            color: Colors.black,
                            size: size * .9,
                          ),
                        ),
                      ),
                    ],
                  )),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "${currentpost["Liked"].length} Likes",
                    ),
                    Expanded(
                        child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                    )),
                    Text(
                      widget.date,
                    ),
                  ],
                ),
              )
            ],
          );
  }
}

Future _commentSection(BuildContext context) async {
  final result = await showModalBottomSheet(
    showDragHandle: true,
    enableDrag: true,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * .7,
        child: Column(
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
              onTap: () {},
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
        ),
      );
    },
  );
  // Handle the result returned from the bottom sheet (if any)
  return result;
}
