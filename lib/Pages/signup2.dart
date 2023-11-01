import 'package:flutter/material.dart';
import 'package:fucare_android_studio/Pages/signup.dart';
import 'package:fucare_android_studio/widget/title_main.dart';
import 'package:fucare_android_studio/widget/value_field.dart';
import 'package:get/get.dart';

class Signup2 extends StatefulWidget {
  const Signup2({super.key});

  @override
  State<Signup2> createState() => _Signup2State();
}

class _Signup2State extends State<Signup2> {
  final SignupFormController signupFormController = Get.find();

  @override
  Widget build(BuildContext context) {
    Get.put(SignupController());
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidht = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 229, 248),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Align(
            //     alignment: Alignment.topRight,
            //     child: Padding(
            //       padding: const EdgeInsets.all(20.0),
            //       child: GestureDetector(
            //         onTap: () {
            //           signupFormController.emailOTPController.sendOTP(
            //               signupFormController
            //                   .signupController.email.value.text);

            //           Get.toNamed('/signup/signup2/verification');
            //         },
            //         child: const Text(
            //           "SKIP",
            //           style: TextStyle(
            //               fontFamily: "Inter",
            //               fontSize: 20,
            //               fontWeight: FontWeight.bold),
            //         ),
            //       ),
            //     )),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * .2),
              child: Padding(
                padding: const EdgeInsets.only(bottom: .0),
                child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/images/signUpBox.png'),
                    fit: BoxFit.cover,
                  )),
                  height: screenHeight * .8,
                ),
              ),
            ),

            // Title Name ---------------------------------------------------------
            Padding(
              padding: EdgeInsets.only(
                top: screenHeight * .16,
              ),
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  "Additional Information",
                  style: TextStyle(
                    fontSize: 26,
                    fontFamily: 'AbhayaLibre',
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 30, 30, 30),
                  ),
                ),
              ),
            ),
            const TitleMain(color: Color.fromARGB(255, 15, 121, 147)),

            Padding(
              padding: EdgeInsets.only(
                top: screenHeight * .22,
                left: 20,
                right: 20,
              ),
              child: SignupForm(
                controller: signupFormController,
                screenHeight: screenHeight,
                screenWidht: screenWidht,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  final SignupFormController controller;
  final double screenHeight;
  final double screenWidht;

  const SignupForm({
    super.key,
    required this.controller,
    required this.screenHeight,
    required this.screenWidht,
  });

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          // ... Your form fields ...

          //Text 1 --------------------------------------------------------------------------------------------------
          const CustomText(title: 'LinkedIn Url'),
          // Text Field 1 --------------------------------------------------------------------------------------------------
          ValueField(
            icon: Icons.link,
            controller: widget.controller.signupController.linkedinUrl.value,
          ),
          SizedBox(
            height: widget.screenHeight * 0.01,
          ),
          //Text 2 --------------------------------------------------------------------------------------------------
          const CustomText(title: 'Bio'),
          // Text Field 1 --------------------------------------------------------------------------------------------------
          Container(
            height: MediaQuery.of(context).size.height * .2,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                border: Border.all(
                    color: const Color.fromARGB(255, 40, 40, 40), width: 0),
                borderRadius: BorderRadius.circular(21)),
            child: TextField(
              controller: widget.controller.signupController.bio.value,
              expands: false,
              style: const TextStyle(fontSize: 20.0, color: Colors.black54),
              maxLines: 11,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color.fromARGB(255, 40, 40, 40)),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color.fromARGB(255, 40, 40, 40)),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                contentPadding: const EdgeInsets.all(12.0),
                hintText: "Write Something...",
                alignLabelWithHint: true,
              ),
            ),
          ),
          SizedBox(
            height: widget.screenHeight * 0.01,
          ),

          //Text 3 --------------------------------------------------------------------------------------------------
          const CustomText(title: 'Portfolio Url'),
          // Text Field 1 --------------------------------------------------------------------------------------------------
          ValueField(
            icon: Icons.link,
            controller: widget.controller.signupController.portfolioUrl.value,
          ),
          SizedBox(
            height: widget.screenHeight * 0.01,
          ),

          widget.controller.signupController.type.value == "Creator"
              ? Column(
                  children: [
                    //Text 4 --------------------------------------------------------------------------------------------------
                    const CustomText(title: 'Working At-'),
                    // Text Field 1 --------------------------------------------------------------------------------------------------
                    ValueField(
                      icon: Icons.work,
                      controller:
                          widget.controller.signupController.workingAt.value,
                    ),
                    SizedBox(
                      height: widget.screenHeight * 0.01,
                    ),

                    //Text 5 --------------------------------------------------------------------------------------------------
                    const CustomText(title: 'Designation'),
                    // Text Field 1 --------------------------------------------------------------------------------------------------
                    ValueField(
                      icon: Icons.work,
                      controller:
                          widget.controller.signupController.designation.value,
                    ),
                    SizedBox(
                      height: widget.screenHeight * 0.01,
                    ),
                  ],
                )
              : Container(),
          SizedBox(
            height: widget.screenHeight * 0.01,
          ),
          // Sign Up Button
          SizedBox(
            height: 50,
            width: 180,
            child: ElevatedButton(
              onPressed: () {
                widget.controller.emailOTPController.sendOTP(
                    widget.controller.signupController.email.value.text);

                Get.toNamed('/signup/signup2/verification');
              },
              style: ElevatedButton.styleFrom(
                elevation: 25,
                shadowColor: const Color.fromARGB(255, 0, 0, 0),
                backgroundColor: const Color.fromARGB(255, 227, 117, 117),
              ),
              child: const Text(
                'Next',
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: widget.screenHeight * 0.04,
          ),
        ],
      ),
    );
  }
}
