// ignore_for_file: unused_local_variable

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fucare_android_studio/Pages/navbar.dart';
import 'package:fucare_android_studio/services/image.dart';
import 'package:fucare_android_studio/services/message_widget.dart';
import 'package:fucare_android_studio/services/uniqueid.dart';
import 'package:fucare_android_studio/services/userdata.dart';
import 'package:fucare_android_studio/services/userdataformat.dart';
import 'package:get/get.dart';


// Controller which gives list of messages, current message, length of no of messages.
class MessageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController _controller;
  Rx<TextEditingController> textController = TextEditingController().obs;
  final dynamic foi = [].obs;
  Userdetail userdetailcontroller = Get.find();
  final field = "".obs;
  RxList<Widget> list = <Widget>[].obs;
  final RxInt _selectedIndex = 0.obs;
  final RxInt indexContent = 0.obs;
  final Rx<List<dynamic>> messageList = Rx([]); // Make it nullable
  final Rx<dynamic> message = Rx<dynamic>(null);
  RxBool islaoding = true.obs;
  RxBool isloading2 = false.obs;
  final RxInt length = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _controller =
        TabController(length: userdetailcontroller.length.value, vsync: this);
    foi.value = userdetailcontroller.currentuser.value[0]["Field of Interest"];
    field.value = foi[0];
    fetchTab();
    // Call the asynchronous function when the controller is initialized
    fetchMsg().whenComplete(() {
      _controller.addListener(() {
        _selectedIndex.value = _controller.index;
        indexContent.value = _selectedIndex.value;
        field.value = foi[indexContent.value];
        fetchMsg();
      });
    });
  }

  Future<void> fetchTab() async {
    for (int x = 0; x < foi.value.length; x++) {
      String title = foi.value[x];
      list.add(
        Tab(
          text: title,
        ),
      );
    }
  }


  // Function to fetch all messages ----------------------------------------------------------------
  Future<void> fetchMsg() async {
    try {
      // Use the getMessagelist function to get the message stream
      Stream<QuerySnapshot> userStream =
          DatabaseManager().getMessagelist(field.value);
      userStream.listen((QuerySnapshot quersnapshot) {
        messageList.value = [];
        for (QueryDocumentSnapshot doc in quersnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          message.value = data;
          messageList.value.add(message.value);
        }
        length.value = messageList.value.length;
        islaoding.value = false;
      });
    } catch (e) {
      // Handle any exceptions here
    }
  }
}

class Community extends StatefulWidget {
  const Community({super.key});
  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community>
    with SingleTickerProviderStateMixin {
  Userdetail userdetailcontroller = Get.find();
  ImageController imageController = Get.put(ImageController());
  MessageController messageController = Get.put(MessageController());

  bool cond2 = false;

  List field = [''];
  Map<String, dynamic> message = {};
  int indexContent = 0;
  int len = 0;
  Map<String, dynamic> messagedatalist = {};
  List currentUserData = [];
  List<Widget> list = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> setter() async {
    dynamic resultant = await DatabaseManager().getCurrentUser();
    setState(() {
      currentUserData = resultant;
      for (int x = 0; x < userdetailcontroller.length.value; x++) {
        field = resultant[0]['Field of Interest'];
        String title = resultant[0]['Field of Interest'][x];
        list.add(
          Tab(
            text: title,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 220, 229, 248),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              labelStyle: const TextStyle(
                  fontFamily: "Inter",
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              isScrollable: true,
              onTap: (index) {
                // Should not used it as it only called when tab options are clicked,
                // not when user swapped
              },
              controller: messageController._controller,
              tabs: messageController.list,
            ),
          ),
        ),
        title: const Text('Community',
            style: TextStyle(
                fontFamily: "Inter",
                fontSize: 24,
                fontWeight: FontWeight.bold)),
      ),
      body: TabBarView(
        controller: messageController._controller,
        children: messageController.list.map((tab) {
          return Stack(
            children: [
              Container(
                // Background image       // Listen to updates in the stream

                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/lawyerbackground.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                height: MediaQuery.of(context).size.height * 1,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: 1, sigmaY: 1), 
                ),
              ),
              Obx(
                () {
                  bool cond = messageController.islaoding.value;
                  bool cond2 = messageController.isloading2.value;
                  int length = messageController.length.value;
                  String selectedImageUrl =
                      imageController.selectedImageUrl.value;
                  final messagedatalist = messageController.messageList.value;
                  return cond
                      ? const Center(
                          child: SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator()))
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                //Setting height of message preview box on the basis if image is present or not
                                height: selectedImageUrl.isEmpty
                                    ? MediaQuery.of(context).size.height * .71
                                    : MediaQuery.of(context).size.height * .42,
                                child: ListView.builder(
                                  reverse: true,
                                  shrinkWrap:
                                      true, // Make the inner ListView scrollable
                                  itemCount:
                                      length, // Example itemCount, replace with your data
                                  itemBuilder: (context, index) {
                                    // Messagebox widget 
                                    return MessageWidget(
                                        index: index,
                                        messagedatalist: messagedatalist,
                                        length: length,
                                        cond2: cond2);
                                  },
                                ),
                              ),
                              selectedImageUrl.isEmpty
                                  ? Container()
                                  : imageController.isloading.value
                                      ?
                                      // Field to enter message and all.........
                                       Stack(
                                          alignment: Alignment.center,
                                          children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Center(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 2),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        32))),
                                                    child: ClipRRect(
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .vertical(
                                                        top:
                                                            Radius.circular(30),
                                                      ),
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                              color: const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  255,
                                                                  255,
                                                                  255),
                                                              border: Border.all(
                                                                  width: 1)),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              .8,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              .28,
                                                          child: AspectRatio(
                                                            aspectRatio: 1 / 1,
                                                            child: Image.file(
                                                                imageController
                                                                    .selectdImageFile
                                                                    .value,
                                                                fit: BoxFit
                                                                    .fitWidth),
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator())
                                            ])
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Center(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(width: 2),
                                                  borderRadius:
                                                      const BorderRadius
                                                          .vertical(
                                                          top: Radius.circular(
                                                              32))),
                                              child: ClipRRect(
                                                clipBehavior: Clip.antiAlias,
                                                borderRadius:
                                                    const BorderRadius.vertical(
                                                  top: Radius.circular(30),
                                                ),
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: const Color
                                                            .fromARGB(255, 255,
                                                            255, 255),
                                                        border: Border.all(
                                                            width: 1)),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .8,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .28,
                                                    child:
                                                    // Image for preview after selecting
                                                     AspectRatio(
                                                      aspectRatio: 1 / 1,
                                                      child: Image.file(
                                                          imageController
                                                              .selectdImageFile
                                                              .value,
                                                          fit: BoxFit.fitWidth),
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ),
                              Padding(
                                padding: selectedImageUrl.isEmpty
                                    ? const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10)
                                    : const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 10),
                                child: Row(
                                  children: [
                                    Material(
                                      elevation:
                                          selectedImageUrl.isEmpty ? 0 : 10,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                20,
                                        child: TextField(
                                          controller: messageController
                                              .textController.value,
                                          style: const TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black54),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white, //
                                            hintText: "Type a Message...",
                                            hintStyle: const TextStyle(
                                                color: Colors.black38),
                                            contentPadding:
                                                const EdgeInsets.all(12.0),
                                            prefixIcon: selectedImageUrl.isEmpty
                                                ? IconButton(
                                                    icon: const Icon(
                                                      Icons.camera_alt,
                                                      color: Color.fromARGB(
                                                          200, 0, 0, 0),
                                                      size: 25,
                                                    ),
                                                    onPressed: () {
                                                      imageController
                                                          .imagePicker();
                                                    },
                                                  )
                                                : IconButton(
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Color.fromARGB(
                                                          198, 220, 1, 1),
                                                      size: 25,
                                                    ),
                                                    onPressed: () {
                                                      imageController
                                                          .selectedImageUrl
                                                          .value = '';
                                                    },
                                                  ),
                                            // Send Message 
                                            suffixIcon: IconButton(
                                                onPressed: () async {

                                                  DateTime now = DateTime.now();
                                                  String id = uidGenerator(
                                                      userdetailcontroller
                                                          .currentuser
                                                          .value[0]['Email'],
                                                      "Message",
                                                      now);
                                                  if (selectedImageUrl
                                                          .isEmpty &&
                                                      messageController
                                                              .textController
                                                              .value
                                                              .text ==
                                                          "") {
                                                    // print("Enter something");
                                                  } else if (selectedImageUrl
                                                      .isEmpty) {
                                                    final currentmessage =
                                                        MessageData(
                                                      uid: id,
                                                      sender:
                                                          userdetailcontroller
                                                                  .currentuser
                                                                  .value[0]
                                                              ['Email'],
                                                      currentdatetime: now,
                                                      message: messageController
                                                          .textController
                                                          .value
                                                          .text
                                                          .toString(),
                                                      imageurl: "",
                                                    );

                                                    await Get.put(
                                                            SendMessageData(
                                                                context))
                                                        .sendMessage(
                                                      currentmessage,
                                                      messageController
                                                          .field.value,
                                                    )
                                                        .whenComplete(() {
                                                      messageController
                                                          .textController.value
                                                          .clear();
                                                      imageController
                                                          .selectedImageUrl
                                                          .value = '';
                                                      selectedImageUrl =
                                                          imageController
                                                              .selectedImageUrl
                                                              .value;
                                                      Get.delete<
                                                          ImageController>();
                                                      imageController.isloading
                                                          .value = false;
                                                    });
                                                  } else {
                                                    String path =
                                                        userdetailcontroller
                                                                    .currentuser
                                                                    .value[0]
                                                                ["Email"] +
                                                            DateTime.now()
                                                                .toString();
                                                    imageController
                                                        .isloading.value = true;
                                                    imageController
                                                        .uploadImage(path)
                                                        .whenComplete(() async {
                                                      final currentmessage =
                                                          MessageData(
                                                        uid: id,
                                                        sender:
                                                            userdetailcontroller
                                                                    .currentuser
                                                                    .value[0]
                                                                ['Email'],
                                                        currentdatetime:
                                                            DateTime.now(),
                                                        message:
                                                            messageController
                                                                .textController
                                                                .value
                                                                .text
                                                                .toString(),
                                                        imageurl: imageController
                                                            .uploadedimageUrl
                                                            .value,
                                                      );

                                                      await Get.put(
                                                              SendMessageData(
                                                                  context))
                                                          .sendMessage(
                                                        currentmessage,
                                                        messageController
                                                            .field.value,
                                                      )
                                                          .whenComplete(() {
                                                        messageController
                                                            .textController
                                                            .value
                                                            .clear();
                                                        imageController
                                                            .selectedImageUrl
                                                            .value = '';
                                                        selectedImageUrl =
                                                            imageController
                                                                .selectedImageUrl
                                                                .value;
                                                        Get.delete<
                                                            ImageController>();
                                                        imageController
                                                            .isloading
                                                            .value = false;
                                                      });
                                                    });
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.send,
                                                  size: 30,
                                                )),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                },
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
