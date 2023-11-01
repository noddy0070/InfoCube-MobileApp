import 'package:flutter/material.dart';
import 'package:fucare_android_studio/Pages/profilepicture.dart';
import 'package:fucare_android_studio/Pages/signup.dart';
import 'package:fucare_android_studio/Pages/verification.dart';
import 'package:fucare_android_studio/services/auth_services.dart';
import 'package:fucare_android_studio/services/userdata.dart';
import 'package:fucare_android_studio/services/userdataformat.dart';
import 'package:fucare_android_studio/widget/buttons.dart';
import 'package:fucare_android_studio/widget/title_main.dart';
import 'package:get/get.dart';

class FOIController extends GetxController {
  final interests = <String>[].obs;

  void toggleInterest(String field) {
    if (interests.contains(field)) {
      interests.remove(field);
    } else {
      interests.add(field);
    }
  }
}

class FOIpage extends StatelessWidget {
  final FOIController controller = Get.put(FOIController());
  final SignupFormController signupFormController = Get.find();
  final SignupController signupController = Get.find();
  final VerificationController verificationController = Get.find();
  final ProfileController profileController = Get.find();

  FOIpage({
    Key? key,
  }) : super(key: key);

  final List<String> fields = [
    "JEE",
    "NEET",
    "Defence",
    "Engineering",
    "Astronomy",
    "Software Development",
    "Designing",
    "Civil Services",
    "Teaching",
    "Startup",
    "Aviation",
    "Lawyer",
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 229, 248),
      body: Stack(
        children: [
          Container(
            // Background image //
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/foiBox.png'),
                fit: BoxFit.cover,
              ),
            ),
            height: screenHeight * 1.5,
          ),
          Column(
            children: [
              const TitleMain(
                color: Color.fromARGB(255, 220, 229, 248),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Choose your Field of Interest\nfor frequent Updates",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: 'AbhayaLibre',
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 30, 30, 30),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
                  children: [
                    for (int x = 0; x < fields.length; x++)
                      Column(
                        children: [
                          Obx(() => InterestBtn(
                                width: double.infinity,
                                color: controller.interests.contains(fields[x])
                                    ? Colors.redAccent
                                    : const Color.fromARGB(255, 117, 188, 227),
                                fnc: () {
                                  controller.toggleInterest(fields[x]);
                                },
                                title: fields[x],
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    MainBtn(
                      width: 150,
                      fnc: () async {
                        if (controller.interests.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Select at least\nOne Field of Interest")));
                        } else {
                          String firstname = signupFormController
                              .signupController.firstName.value.text
                              .trim()
                              .toString()
                              .toLowerCase();
                          String lastname = signupFormController
                              .signupController.lastName.value.text
                              .trim()
                              .toString()
                              .toLowerCase();
                          final userData = UserData(
                              firstName: firstname[0].toUpperCase() +
                                  firstname.substring(1),
                              lastName: lastname[0].toUpperCase() +
                                  lastname.substring(1),
                              email: signupFormController
                                  .signupController.email.value.text
                                  .trim()
                                  .toString(),
                              password: signupFormController
                                  .signupController.password.value.text
                                  .trim()
                                  .toString(),
                              dob: signupFormController.signupController.dob.value.text
                                  .trim()
                                  .toString(),
                              gender: signupFormController
                                  .signupController.selectedGender.value
                                  .toString(),
                              education: signupFormController
                                  .signupController.selectedClass.value
                                  .toString(),
                              interest: controller.interests,
                              type: signupFormController
                                  .signupController.type.value,
                              profileimageurl:
                                  profileController.profileimageurl.value,
                              region: signupFormController
                                  .signupController
                                  .selectedstate
                                  // ignore: invalid_use_of_protected_member
                                  .value,
                              bio: signupFormController
                                  .signupController.bio.value.text,
                              workingAt: signupFormController
                                  .signupController.workingAt.value.text,
                              designation: signupFormController
                                  .signupController.designation.value.text,
                              portfolioUrl: signupFormController
                                  .signupController.portfolioUrl.value.text,
                              linkedinUrl: signupFormController.signupController.linkedinUrl.value.text,
                             );
                          await Get.put(CreateUserdata(context))
                              .createUser(
                                userData,
                              )
                              .whenComplete(() async {
                                await verificationController.createUser();
                                Get.snackbar(
                                    "Account Created Successfully", "");
                              })
                              .whenComplete(() async =>
                                  await Authentication.signOut(
                                      context: context))
                              .whenComplete(() => Get.offAllNamed('/'))
                              .whenComplete(() => null);
                        }
                      },
                      title: "Next",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
