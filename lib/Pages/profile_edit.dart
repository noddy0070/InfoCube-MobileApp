// ignore_for_file: invalid_use_of_protected_member

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fucare_android_studio/Pages/navbar.dart';
import 'package:fucare_android_studio/services/image_new.dart';
import 'package:fucare_android_studio/services/userdata.dart';
import 'package:fucare_android_studio/services/userdataformat.dart';
import 'package:fucare_android_studio/widget/buttons.dart';
import 'package:fucare_android_studio/widget/imageholder.dart';
import 'package:fucare_android_studio/widget/value_field.dart';
import 'package:get/get.dart';

class ProfileEditController extends GetxController {
  Userdetail userdetail = Get.find();
  final selectedGender = '--Select--'.obs;
  final selectedClass = '10th'.obs;
  RxList<String> selectedstate = [" ", 'State', 'City'].obs;
  final firstName = TextEditingController().obs;
  final lastName = TextEditingController().obs;
  final dob = TextEditingController().obs;
  final email = TextEditingController().obs;
  final linkedinUrl = TextEditingController().obs;
  final portfolioUrl = TextEditingController().obs;
  final bio = TextEditingController().obs;
  final workingAt = TextEditingController().obs;
  final designation = TextEditingController().obs;
  final isValidDOB = true.obs;
  final cond = false.obs;
  final cond2 = false.obs;
  final check = true.obs;
  final documentId = "".obs;
  final profileImageUrl = "".obs;
  final isUploading = false.obs;
  Rx<File> selectedimage = File("").obs;

  @override
  void onInit() {
    super.onInit();
    settingValueController();
    settingValueController2();
    setdocid();
  }

  Future<void> setdocid() async {
    documentId.value = await DatabaseManager().getDocumentId(email.value.text);
  }

  void validateDOB(String dob) {
    final regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    isValidDOB.value = regex.hasMatch(dob);
  }

  settingValueController() {
    firstName.value.text = userdetail.currentuser.value[0]["First Name"];
    lastName.value.text = userdetail.currentuser.value[0]["Last Name"];
    dob.value.text = userdetail.currentuser.value[0]["Date of Birth"];
    bio.value.text = userdetail.currentuser.value[0]["Bio"];
    selectedstate.value[0] =
        userdetail.currentuser.value[0]["Region"][0] ?? "Country";
    selectedstate.value[1] =
        userdetail.currentuser.value[0]["Region"][1] ?? "State";
    selectedstate.value[2] =
        userdetail.currentuser.value[0]["Region"][2] ?? "City";
    selectedGender.value = userdetail.currentuser.value[0]["Gender"];
    email.value.text = userdetail.currentuser.value[0]["Email"];
    portfolioUrl.value.text = userdetail.currentuser.value[0]["Portfolio Url"];
    linkedinUrl.value.text =
        userdetail.currentuser.value[0]["LinkedIn Url"] ?? "";
    selectedClass.value = userdetail.currentuser.value[0]["Education"];
    workingAt.value.text = userdetail.currentuser.value[0]["Working At"] ?? "";
    designation.value.text = userdetail.currentuser.value[0]["Designation"];
  }

  settingValueController2() {
    profileImageUrl.value = userdetail.currentuser.value[0]["ProfileUrl"];
  }
}

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final Userdetail userdetailcontroller = Get.find();
  ProfileEditController profileEditController =
      Get.put(ProfileEditController());
  ImageControllerProfilePicture imageControllerProfilePicture =
      Get.put(ImageControllerProfilePicture());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 220, 229, 248),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 220, 229, 248),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Obx(() {
            bool check = profileEditController.check.value;
            bool cond = profileEditController.cond.value;
            bool cond2 = profileEditController.cond2.value;
            return Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .18,
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .44,
                          child: const Text(
                            "Your\nProfile",
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * .09),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .3,
                          child: Stack(
                            children: [
                              userdetailcontroller.currentuser.value[0]
                                          ["ProfileUrl"] ==
                                      "assets/images/defaultprofile.jpg"
                                  ? const CircularImageWidget()
                                  : !cond2
                                      ? CircularImageWidget2(
                                          imageurl: userdetailcontroller
                                              .currentuser
                                              .value[0]["ProfileUrl"])
                                      : CircularImageWidget3(
                                          imagefile: profileEditController
                                              .selectedimage.value,
                                        ),
                              Positioned(
                                bottom: 2,
                                right: 7,
                                child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            Color.fromARGB(255, 251, 251, 251)),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (cond2 == false) {
                                          imageControllerProfilePicture
                                              .showImagePicker(context)
                                              .whenComplete(() {});
                                        } else if (cond2 == true) {
                                          _showConfirmationDialog2(context);
                                        }

                                        const InkWell();
                                      },
                                      child: Icon(
                                        cond2 ? Icons.done : Icons.edit,
                                        color: const Color.fromARGB(
                                            255, 169, 169, 169),
                                        size: 30,
                                      ),
                                    )),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * .02,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    MainBtn(
                      width: MediaQuery.of(context).size.width * .43,
                      fnc: () {
                        profileEditController.check.value = true;
                        profileEditController.cond.value = false;
                      },
                      title: "Personal",
                      color: check
                          ? const Color.fromARGB(255, 8, 117, 114)
                          : const Color.fromARGB(255, 220, 229, 248),
                      textStyle: check
                          ? const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)
                          : const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                      bordercolor: const Color.fromARGB(255, 8, 117, 114),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * .06),
                    MainBtn(
                      width: MediaQuery.of(context).size.width * .43,
                      fnc: () {
                        setState(() {
                          profileEditController.check.value = false;
                          profileEditController.cond.value = false;
                        });
                      },
                      title: "Profesional",
                      bordercolor: const Color.fromARGB(255, 8, 117, 114),
                      color: check
                          ? const Color.fromARGB(255, 220, 229, 248)
                          : const Color.fromARGB(255, 8, 117, 114),
                      textStyle: check
                          ? const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)
                          : const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * .06,
              ),
              ProfileEditForm(
                profileEditController: profileEditController,
                check: profileEditController.check.value,
                cond: profileEditController.cond.value,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * .06,
              ),
              MainBtn(
                  width: MediaQuery.of(context).size.width * .5,
                  fnc: () {
                    if (cond == true) {
                      _showConfirmationDialog(context);
                    }
                    if (cond == false) {
                      profileEditController.cond.value = true;
                    }
                  },
                  title: cond ? "Confirm" : "Edit")
            ]);
          }),
        ));
  }
}

Future<void> _showConfirmationDialog(BuildContext context) async {
  Userdetail userdetail = Get.find();
  ProfileEditController profileEditController = Get.find();
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User must tap button to dismiss the dialog
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Edit Profile'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to edit your profile?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              profileEditController.settingValueController();
              profileEditController.cond.value = false;
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: const Text('Confirm'),
            onPressed: () async {
              profileEditController
                  .validateDOB(profileEditController.dob.value.text);
              if (!profileEditController.isValidDOB.value) {
                Get.snackbar("Enter Date of Birth\nin correct format", "");
                Navigator.of(context).pop();
              } else {
                final user = UserDataUpdated(
                    firstName: profileEditController.firstName.value.text
                        .toString()
                        .trim(),
                    lastName: profileEditController.lastName.value.text
                        .toString()
                        .trim(),
                    dob: profileEditController.dob.value.text.toString().trim(),
                    bio: profileEditController.bio.value.text.toString().trim(),
                    linkedinUrl: profileEditController.linkedinUrl.value.text
                        .toString()
                        .trim(),
                    portfolioUrl: profileEditController.portfolioUrl.value.text
                        .toString()
                        .trim(),
                    workingAt: profileEditController.workingAt.value.text
                        .toString()
                        .trim(),
                    designation: profileEditController.designation.value.text
                        .toString()
                        .trim());

                await Get.put(UpdateUserdata(context).updateUser(
                        profileEditController.documentId.value, user))
                    .whenComplete(() {
                  profileEditController.cond.value = false;
                  userdetail.fetchCurrentUser();
                  Navigator.of(context).pop();
                });
              }
              // Close the dialog
            },
          ),
        ],
      );
    },
  );
}

Future<void> _showConfirmationDialog2(BuildContext context) async {
  Userdetail userdetail = Get.find();
  ImageControllerProfilePicture imageControllerProfilePicture = Get.find();
  ProfileEditController profileEditController = Get.find();
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User must tap button to dismiss the dialog
    builder: (BuildContext context) {
      return Obx(() {
        bool uploading = profileEditController.isUploading.value;
        return Stack(
          children: [
            AlertDialog(
              title: const Text('Confirm New Profile Picture'),
              content: const SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Are you sure you want to edit your profile picture?'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    profileEditController.settingValueController2();
                    profileEditController.cond2.value = false;
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
                TextButton(
                    child: const Text('Yes'),
                    onPressed: () async {
                      profileEditController.isUploading.value = true;
                      String path =
                          profileEditController.email.value.text.toString();
                      await imageControllerProfilePicture
                          .uploadImage(path)
                          .whenComplete(() async {
                        Map<String, String> img = {
                          "ProfileUrl": imageControllerProfilePicture
                              .uploadedimageUrl.value
                        };

                        await Get.put(UpdateUserProfilePicdata(context)
                                .updateUser(
                                    profileEditController.documentId.value,
                                    img))
                            .whenComplete(() {
                          profileEditController.cond2.value = false;
                          userdetail.fetchCurrentUser();
                          Navigator.of(context).pop();
                          profileEditController.isUploading.value = false;
                        });
                      }
                              // Close the dialog

                              );
                    })
              ],
            ),
            uploading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(),
          ],
        );
      });
    },
  );
}

class ProfileEditForm extends StatefulWidget {
  final ProfileEditController profileEditController;
  final bool check;
  final bool cond;
  const ProfileEditForm(
      {super.key,
      required this.profileEditController,
      required this.check,
      required this.cond});

  @override
  State<ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> {
  Userdetail userdetail = Get.find();
  List<String> personalDetails = [
    "First Name",
    "Last Name",
    "Date of Birth",
    "Bio",
    "Region",
    "Gender"
  ];

  List<String> professionalDetails = [
    "Email",
    "Portfolio Url",
    "LinkedIn Url",
    "Education",
    "Working At",
    "Designation"
  ];
  List<IconData> iconPersonal = [
    Icons.person,
    Icons.person,
    Icons.calendar_month,
    Icons.person,
    Icons.location_on,
    Icons.male
  ];
  List<IconData> iconProfessional = [
    Icons.mail,
    Icons.link,
    Icons.link,
    Icons.work,
    Icons.work,
    Icons.work
  ];

  late List<dynamic> controllerPersonal = [
    widget.profileEditController.firstName.value,
    widget.profileEditController.lastName.value,
    widget.profileEditController.dob.value,
    widget.profileEditController.bio.value,
    widget.profileEditController.selectedstate.value,
    widget.profileEditController.selectedGender.value
  ];

  late List<dynamic> controllerProfessional = [
    widget.profileEditController.email.value,
    widget.profileEditController.portfolioUrl.value,
    widget.profileEditController.linkedinUrl.value,
    widget.profileEditController.selectedClass.value,
    widget.profileEditController.workingAt.value,
    widget.profileEditController.designation.value
  ];
  String userEmail = '';
  int selectedIndex = 0;

  List currentuser = [''];

  @override
  void initState() {
    super.initState();
    userEmail = userdetail.currentuser.value[0]['Email'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      height: MediaQuery.of(context).size.height * .52,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
        itemCount:
            widget.check ? personalDetails.length : professionalDetails.length,
        itemBuilder: (BuildContext context, int index) {
          return widget.check
              ?
              //Column of Personal Fields in starting
              Column(
                  children: [
                    index < 3
                        ? Column(
                            children: [
                              Column(
                                children: [
                                  CustomText(
                                    title: personalDetails[index],
                                  ),
                                  ValueField2(
                                    controller: controllerPersonal[index],
                                    cond: widget.cond,
                                    icon: iconPersonal[index],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        .02,
                                  ),
                                ],
                              ),
                            ],
                          )
                        : //Container for index greater than 2
                        Column(
                            children: [
                              Column(children: [
                                //Index ==3
                                index == 3
                                    ? //Text 2 --------------------------------------------------------------------------------------------------
                                    Column(
                                        children: [
                                          CustomText(
                                              title: personalDetails[index]),
                                          // Text Field 1 --------------------------------------------------------------------------------------------------
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .2,
                                            decoration: ShapeDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color.fromARGB(
                                                      103, 27, 26, 26),
                                                  Color.fromARGB(
                                                      255, 255, 255, 255)
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                stops: [0.0, .02],
                                                tileMode: TileMode.clamp,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: widget.cond
                                                    ? const BorderRadius.all(
                                                        Radius.circular(20.0))
                                                    : const BorderRadius.all(
                                                        Radius.circular(10.0)),
                                              ),
                                            ),
                                            child: TextField(
                                              enabled: widget.cond,
                                              controller:
                                                  controllerPersonal[index],
                                              expands: false,
                                              style: const TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.black54),
                                              maxLines: 11,
                                              decoration: InputDecoration(
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 40, 40, 40)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 40, 40, 40)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color.fromARGB(
                                                          159, 215, 215, 215)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.all(12.0),
                                                hintText: "Write Something...",
                                                alignLabelWithHint: true,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                        ],
                                      )
                                    : Container(),
                                // Index ==4
                                index == 4
                                    ? Column(
                                        children: [
                                          CustomText(
                                              title: personalDetails[index]),
                                          ValueField2(
                                            controller: TextEditingController(),
                                            cond: false,
                                            icon: iconPersonal[index],
                                            labeltext:
                                                "${controllerPersonal[index][2]}, ${controllerPersonal[index][1]}",
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                        ],
                                      )
                                    : Container(),
                                //index==5
                                // index == 5
                                //     ? Column(
                                //         children: [
                                //         ],
                                //       )
                                //     : Container(),
                              ])
                            ],
                          ),
                  ],
                )
              :

              ///Column of professional is starting
              Column(
                  children: [
                    index == 3
                        ? Container()
                        : Column(
                            children: [
                              CustomText(
                                title: professionalDetails[index],
                              ),
                              ValueField2(
                                controller: controllerProfessional[index],
                                cond: index == 0 ? false : widget.cond,
                                icon: iconProfessional[index],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .02,
                              ),
                            ],
                          ),
                  ],
                );
        },
      ),
    );
  }
}
