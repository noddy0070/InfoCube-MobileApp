import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/material.dart';
import 'package:fucare_android_studio/Pages/contents.dart';
import 'package:fucare_android_studio/services/userdata.dart';
import 'package:get/get.dart';

class ContentSelectedController extends GetxController {
  RxList<dynamic> contentDataList = <dynamic>[].obs;
  RxString text = "No data".obs;
  Rx<TextEditingController> textcontroller = TextEditingController().obs;
  RxString type = "".obs;
  RxDouble width = 200.0.obs;
  RxDouble height = 200.0.obs;
  RxDouble top = 50.0.obs;
  RxDouble left = 59.0.obs;
  RxDouble width2 = 200.0.obs;
  RxDouble height2 = 200.0.obs;
  RxDouble top2 = 50.0.obs;
  RxDouble left2 = 59.0.obs;
  RxBool isShowing = false.obs;
  RxString imageUrl = ''.obs;
  RxBool sizeposition = false.obs;
  RxBool sizeposition2 = false.obs;
  void fetchContentData() async {
    final resultant = await DatabaseManager().getContentData();
    if (resultant == null) {
      // print("Error in fetching data");
    } else {
      contentDataList.assignAll(resultant);
    }
    text.value =
        contentDataList.isNotEmpty ? contentDataList[0].toString() : "No data";
    imageUrl.value = ''; // Set the image URL here
  }

  void updatesize(Offset offset) {
    height.value += offset.dy;
    width.value += offset.dx;
  }

  void updateposition(Offset offset) {
    top.value += offset.dy;
    left.value += offset.dx;
  }

  void updatesize2(Offset offset) {
    height2.value += offset.dy;
    width2.value += offset.dx;
  }

  void updateposition2(Offset offset) {
    top2.value += offset.dy;
    left2.value += offset.dx;
  }
}

class ContentSelected extends StatefulWidget {
  const ContentSelected({super.key});

  @override
  State<ContentSelected> createState() => _ContentSelectedState();
}

class _ContentSelectedState extends State<ContentSelected> {
  final ContentSelectedController contentselectedcontroller =
      Get.put(ContentSelectedController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDrawerOpen = false;

  final ContentController contentController = Get.find();

  @override
  Widget build(BuildContext context) {
    double actualHeight = MediaQuery.of(context).size.height;
    double actualWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      onDrawerChanged: (val) {
        if (val) {
          setState(() {
            isDrawerOpen = true;
          });
        } else {
          setState(() {
            isDrawerOpen = false;
          });
        }
      },
      backgroundColor: const Color.fromARGB(255, 220, 229, 248),
      appBar: AppBar(
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu), // Your drawer icon
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
              iconSize: 40.0, // Set the size of the icon here
            );
          },
        ),
        title: Text(
          isDrawerOpen ? "" : contentController.selectedContent.value,
          style: const TextStyle(
              fontFamily: "Georgia", fontSize: 36, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 220, 229, 248),
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * .67,
        backgroundColor: const Color.fromARGB(255, 220, 229, 248),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Add your drawer items here
            const SizedBox(
              height: 20,
            ),
            Center(
                child: Text(
              contentController.selectedContent.value,
              style: const TextStyle(
                  fontFamily: "Georgia",
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            )),
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
         const Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   SizedBox(
                    width: 20,
                    height: 200,
                  ),
                   SizedBox(
                    width: 20,
                    height: 200,
                  ),
                  Text(
                    "This is the first text that ia m inserting inside the lawyer field to test the data",
                    style: TextStyle(fontFamily: "Georgia", fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Obx(() {
            String type = contentselectedcontroller.type.value;
            return Positioned(
              bottom: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  contentselectedcontroller.isShowing.value =
                      !contentselectedcontroller.isShowing.value;
                },
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.black)),
                      child: const Icon(
                        Icons.add,
                        size: 50,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          Obx(() {
            bool isShowing = contentselectedcontroller.isShowing.value;
            return isShowing
                ? Positioned(
                    bottom: 60,
                    right: 15,
                    child: Column(
                      children: [
                        // Text Field
                        GestureDetector(
                          onTap: () {
                            if (contentselectedcontroller.type.value ==
                                "Image") {
                              contentselectedcontroller.type.value =
                                  "TextImage";
                            } else {
                              contentselectedcontroller.type.value = "Text";
                            }
                            contentselectedcontroller.isShowing.value =
                                !contentselectedcontroller.isShowing.value;
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(color: Colors.black)),
                            child: const Icon(
                              Icons.text_fields,
                              size: 30,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        //Image button
                        GestureDetector(
                          onTap: () {
                            if (contentselectedcontroller.type.value ==
                                "Text") {
                              contentselectedcontroller.type.value =
                                  "TextImage";
                            } else {
                              contentselectedcontroller.type.value = "Image";
                            }
                            contentselectedcontroller.isShowing.value =
                                !contentselectedcontroller.isShowing.value;
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(color: Colors.black)),
                            child: const Icon(
                              Icons.image,
                              size: 30,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            contentselectedcontroller.isShowing.value =
                                !contentselectedcontroller.isShowing.value;
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(color: Colors.black)),
                            child: const Icon(
                              Icons.videocam,
                              size: 30,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            contentselectedcontroller.type.value = '';
                            contentselectedcontroller.isShowing.value =
                                !contentselectedcontroller.isShowing.value;
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(color: Colors.black)),
                            child: const Icon(
                              Icons.delete,
                              size: 30,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ))
                : const SizedBox();
          }),
          AddingWidget(),
          RichText(
            text: const TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 18),
                children: [
                  TextSpan(text: "Hello"),
                  TextSpan(
                      text: "woow",
                      style: TextStyle(fontWeight: FontWeight.bold))
                ]),
          )
        ],
      ),
    );
  }
}

class AddingWidget extends StatelessWidget {
  AddingWidget({super.key});

  final ContentSelectedController contentselectedcontroller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      String type = contentselectedcontroller.type.value;
      double width = contentselectedcontroller.width.value;
      double height = contentselectedcontroller.height.value;
      double top = contentselectedcontroller.top.value;
      double left = contentselectedcontroller.left.value;
      bool sizeposition = contentselectedcontroller.sizeposition.value;
      double width2 = contentselectedcontroller.width2.value;
      double height2 = contentselectedcontroller.height2.value;
      double top2 = contentselectedcontroller.top2.value;
      double left2 = contentselectedcontroller.left2.value;
      bool sizeposition2 = contentselectedcontroller.sizeposition2.value;
      return type == "Text"
          ? Positioned(
              top: top,
              left: left,
              child: GestureDetector(
                onDoubleTap: () {
                  contentselectedcontroller.sizeposition.value =
                      !contentselectedcontroller.sizeposition.value;
                },
                onHorizontalDragUpdate: (details) {
                  if (sizeposition) {
                    contentselectedcontroller.updatesize(details.delta);
                  } else {
                    contentselectedcontroller.updateposition(details.delta);
                  }
                },
                onVerticalDragUpdate: (details) {
                  if (sizeposition) {
                    contentselectedcontroller.updatesize(details.delta);
                  } else {
                    contentselectedcontroller.updateposition(details.delta);
                  }
                },
                child: Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: sizeposition ? Colors.black : Colors.black26)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: TextField(
                      controller:
                          contentselectedcontroller.textcontroller.value,
                      maxLines: 100,
                      decoration: const InputDecoration(
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none),
                    ),
                  ),
                ),
              ))
          : type == "Image"
              ? Positioned(
                  top: top2,
                  left: left2,
                  child: GestureDetector(
                    onDoubleTap: () {
                      contentselectedcontroller.sizeposition2.value =
                          !contentselectedcontroller.sizeposition2.value;
                    },
                    onHorizontalDragUpdate: (details) {
                      if (sizeposition2) {
                        contentselectedcontroller.updatesize2(details.delta);
                      } else {
                        contentselectedcontroller
                            .updateposition2(details.delta);
                      }
                    },
                    onVerticalDragUpdate: (details) {
                      if (sizeposition2) {
                        contentselectedcontroller.updatesize2(details.delta);
                      } else {
                        contentselectedcontroller
                            .updateposition2(details.delta);
                      }
                    },
                    child: Container(
                      width: width2,
                      height: height2,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: sizeposition2
                                  ? Colors.black
                                  : Colors.black26)),
                      child: Image.asset(
                        'assets/images/layerpic.png',
                        height: contentselectedcontroller.height.value,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ))
              : type == "TextImage"
                  ? Stack(
                      children: [
                        Positioned(
                            top: top,
                            left: left,
                            child: GestureDetector(
                              onDoubleTap: () {
                                contentselectedcontroller.sizeposition.value =
                                    !contentselectedcontroller
                                        .sizeposition.value;
                              },
                              onHorizontalDragUpdate: (details) {
                                if (sizeposition) {
                                  contentselectedcontroller
                                      .updatesize(details.delta);
                                } else {
                                  contentselectedcontroller
                                      .updateposition(details.delta);
                                }
                              },
                              onVerticalDragUpdate: (details) {
                                if (sizeposition) {
                                  contentselectedcontroller
                                      .updatesize(details.delta);
                                } else {
                                  contentselectedcontroller
                                      .updateposition(details.delta);
                                }
                              },
                              child: Container(
                                width: width,
                                height: height,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: sizeposition
                                            ? Colors.black
                                            : Colors.black26)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: TextField(
                                    controller: contentselectedcontroller
                                        .textcontroller.value,
                                    style: const TextStyle(
                                        fontSize: 16, fontFamily: "Georgia"),
                                    maxLines: 100,
                                    decoration: const InputDecoration(
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none),
                                  ),
                                ),
                              ),
                            )),
                        Positioned(
                            top: top2,
                            left: left2,
                            child: GestureDetector(
                              onDoubleTap: () {
                                contentselectedcontroller.sizeposition2.value =
                                    !contentselectedcontroller
                                        .sizeposition2.value;
                              },
                              onHorizontalDragUpdate: (details) {
                                if (sizeposition2) {
                                  contentselectedcontroller
                                      .updatesize2(details.delta);
                                } else {
                                  contentselectedcontroller
                                      .updateposition2(details.delta);
                                }
                              },
                              onVerticalDragUpdate: (details) {
                                if (sizeposition2) {
                                  contentselectedcontroller
                                      .updatesize2(details.delta);
                                } else {
                                  contentselectedcontroller
                                      .updateposition2(details.delta);
                                }
                              },
                              child: Container(
                                width: width2,
                                height: height2,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: sizeposition2
                                            ? Colors.black
                                            : Colors.black26)),
                                child: Image.asset(
                                  'assets/images/layerpic.png',
                                  height:
                                      contentselectedcontroller.height.value,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )),
                      ],
                    )
                  : const SizedBox();
    });
  }
}
