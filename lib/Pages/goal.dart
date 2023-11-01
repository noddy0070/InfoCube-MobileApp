import 'package:flutter/material.dart';
import 'package:fucare_android_studio/Pages/signup.dart';
import 'package:fucare_android_studio/widget/title_main.dart';
import 'package:get/get.dart';

class GoalPage extends StatelessWidget {
  GoalPage({Key? key}) : super(key: key);
  final SignupController signupController = Get.find();
  final SignupFormController signupFormController = Get.find();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidht = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 229, 248),
      body: Stack(
        children: [
          const TitleMain(
            color: Color.fromARGB(255, 15, 121, 147),
          ),
          Padding(
            padding: EdgeInsets.only(top: screenHeight * .25),
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/goalBox.png'),
                      fit: BoxFit.cover)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, top: screenHeight * .17),
            child: SizedBox(
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hey,",
                    style: TextStyle(
                        fontSize: 64,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 45, 45, 45),
                        height: 0),
                    textAlign: TextAlign.end,
                  ),
                  Obx(() => Text(
                        signupFormController
                            .signupController.firstName.value.text
                            .toUpperCase(),
                        style: const TextStyle(
                            fontSize: 50,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            color: Color.fromARGB(255, 227, 107, 107)),
                      )),
                  const Text(
                    "Do you have a\nClear career goal\n OR \nStill uncertain,\nabout your\nchoice.....",
                    style: TextStyle(
                        fontSize: 26,
                        fontFamily: 'Inter',
                        color: Color.fromARGB(255, 45, 45, 45),
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: screenWidht * .5, top: screenHeight * .17),
            child: FractionallySizedBox(
              heightFactor: .64,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/goalPage.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight * .75,
                ),
                SizedBox(
                  height: 50,
                  width: 220,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(
                          '/signup/signup2/verification/profilepicture/goal/foi');
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 25,
                      shadowColor: const Color.fromARGB(255, 0, 0, 0),
                      backgroundColor: const Color.fromARGB(255, 227, 117, 117),
                    ),
                    child: const Text(
                      'I have Fixed Goal',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  width: 260,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(
                          '/signup/signup2/verification/profilepicture/goal/foi');
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 25,
                      shadowColor: const Color.fromARGB(255, 0, 0, 0),
                      backgroundColor: const Color.fromARGB(255, 227, 117, 117),
                    ),
                    child: const Text(
                      'No I am Still Confused',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
