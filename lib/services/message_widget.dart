// ignore_for_file: invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fucare_android_studio/Pages/chat.dart';
import 'package:fucare_android_studio/Pages/navbar.dart';
import 'package:fucare_android_studio/services/userdata.dart';
import 'package:fucare_android_studio/widget/imageholder.dart';
import 'package:fucare_android_studio/widget/messagebox.dart';
import 'package:get/get.dart';

class MessageWidget extends StatefulWidget {
  final int index;
  final bool cond2;
  final int length;
  final List<dynamic> messagedatalist;
  const MessageWidget(
      {super.key,
      required this.index,
      required this.messagedatalist,
      required this.length,
      required this.cond2});

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  final Userdetail userdetailcontroller = Get.find();
  bool longPressCond = false;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> message = {};
    message = widget.messagedatalist[widget.index];
    //// Making size of container adjust according message
    bool cond = (userdetailcontroller.currentuser.value[0]['Email'] ==
        message["Email"]);
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: message["Message"],
        style: const TextStyle(
            fontSize: 16.0,
            fontFamily: "Inter"), // You can adjust the font size as needed
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 250.0); // Set the maximum width

    // ignore: unused_local_variable
    double width =
        textPainter.width + 20.0; // Add padding for better visualization
    double height = cond ? textPainter.height + 20 : textPainter.height + 50.0;

    Timestamp firestoreTimestamp =
        message["Date"]; // Replace with your Timestamp

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
    bool datechange = false;
    String date = "";
    if (widget.index == widget.length - 1) {
      int month = dateTime.month;
      int day = dateTime.day;
      date = "${monthMap[month]} $day";
      datechange = true;
    } else {
      int month = dateTime.month;
      int day = dateTime.day;
      Timestamp datenext = widget.messagedatalist[widget.index + 1]["Date"];
      int month2 = datenext.toDate().month;
      int day2 = datenext.toDate().day;
      if (month != month2 || day != day2) {
        date = "${monthMap[month]} $day";
        datechange = true;
      }
    }
    dynamic currentuser;
    for (int x = 0; x < userdetailcontroller.userdatalist.value.length; x++) {
      if (userdetailcontroller.userdatalist.value[x]["Email"] ==
          message["Email"]) {
        currentuser = userdetailcontroller.userdatalist.value[x];
      }
    }
    String name = "${currentuser["First Name"]} ${currentuser["Last Name"]}";

    // Extract time components
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String time = "$hour:$minute";

    return widget.cond2
        ? const CircularProgressIndicator()
        : Column(
            children: [
              datechange
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 3),
                          child: Text(
                            date,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              Padding(
                padding: cond
                    ? const EdgeInsets.fromLTRB(0, 10, 15, 0)
                    : const EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cond
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                            child: Material(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              child: message["ImageUrl"] ==
                                      "assets/images/defaultprofile.jpg"
                                  ? const CircularImageWidget(
                                      size: 30,
                                      width: 1.5,
                                    )
                                  : CircularImageWidget2(
                                      size: 30,
                                      width: 1,
                                      imageurl: currentuser["ProfileUrl"],
                                    ),
                            ),
                          ),
                    cond
                        ? Expanded(
                            child: Container(
                              height: height, // Height of the container
                            ),
                          )
                        : Container(),
                    message["Email"] ==
                            userdetailcontroller.currentuser.value[0]["Email"]
                        ? GestureDetector(
                            onLongPressStart: (LongPressStartDetails details) {
                              setState(() {
                                longPressCond = true;
                              });
                            },
                            onLongPress: () async {
                              final cond = await _showBottomSheet(
                                  context, message["Uid"]);
                              if (cond == null) {
                                setState(() {
                                  longPressCond = false;
                                });
                              }
                            },
                            onLongPressEnd: (LongPressEndDetails details) {
                              setState(() {
                                longPressCond = false;
                              });
                            },
                            child: Material(
                              elevation: longPressCond ? 5 : 0,
                              clipBehavior: Clip.antiAlias,
                              child: BubbleSpecialOne(
                                text1: cond ? "" : name,
                                text2: message["Message"],
                                text3: time,
                                imageUrl: message["ImageUrl"],
                                textStyle3: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black),
                                color: Colors.white,
                                isSender: cond,
                                textStyle1: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Inter"),
                                textStyle2: const TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                        : Material(
                            clipBehavior: Clip.antiAlias,
                            child: BubbleSpecialOne(
                              text1: cond ? "" : name,
                              text2: message["Message"],
                              text3: time,
                              imageUrl: message["ImageUrl"],
                              textStyle3: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black),
                              color: Colors.white,
                              isSender: cond,
                              textStyle1: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Inter"),
                              textStyle2: const TextStyle(
                                fontFamily: "Inter",
                                fontSize: 16,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          );
  }
}

Future _showBottomSheet(BuildContext context, String uid) async {
  MessageController messageController = Get.find();
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
              'Delete Message',
              style: TextStyle(fontFamily: "Inter", fontSize: 16),
            ),
            onTap: () {
              String messagedocumentid = '';
              fetchMessageDocId() async {
                await FirebaseFirestore.instance
                    .collection("Messages")
                    .doc(messageController.field.value)
                    .collection("GlobalChat")
                    .where("Uid", isEqualTo: uid)
                    .get()
                    .then((value) {
                  messagedocumentid = value.docs[0].id;
                });
              }

              fetchMessageDocId().whenComplete(() {
                DeleteMessage(context)
                    .deleteMessage(
                        messagedocumentid, messageController.field.value)
                    .whenComplete(() {
                  Navigator.pop(context);
                });
              });

            },
          ),
          ListTile(
            leading: const Icon(Icons.copy),
            title: const Text('Copy Text',
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
