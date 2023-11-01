import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fucare_android_studio/Pages/signup.dart';
import 'package:fucare_android_studio/widget/buttons.dart';
import 'package:fucare_android_studio/widget/title_main.dart';
import 'package:get/get.dart';

class VerificationController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var verified = false.obs;
  Future<void> verifyOTP(String otp) async {
    final authController = Get.find<
        EmailOTPController>(); // Get the instance of EmailOTPController
    final auth = authController.myauth;
    if (await auth.verifyOTP(otp: otp)) {
      Get.snackbar("OTP is verified", "");
      verified.value = true;
      // print(verified.value);
    } else {
      Get.snackbar("Invalid OTP", "");
      verified.value = false;
    }
  }

  Future<void> createUser() async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: SignupFormController().signupController.email.value.text,
        password: SignupFormController().signupController.password.value.text,
      );

      if (userCredential.user != null) {
        // print("user created successfully");
      } else {
        // print("failed to create user");
      }
    } catch (e) {

      // print('Error registering user: $e');
      Get.snackbar("Error registering user", "$e");
    }
  }
}

class Verification extends StatelessWidget {
  final VerificationController controller = Get.put(VerificationController());
  final SignupController signupController = Get.find();
  final SignupFormController signupformcontroller = Get.find();
  final EmailOTPController otpController = Get.find();
  final TextEditingController _otp = TextEditingController();
  final RxBool verified = false.obs;
  Verification({super.key});
  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;

    // Use RxBool to make it reactive

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 229, 248),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              // Background image //
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/verifyBox.png'),
                  fit: BoxFit.cover,
                ),
              ),
              height: screenHeight * .85,
            ),
            Column(
              children: [
                const TitleMain(
                  color: Color.fromARGB(255, 220, 229, 248),
                ),
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * .05),
                  child: const Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Email Verification",
                      style: TextStyle(
                        fontSize: 32,
                        fontFamily: 'AbhayaLibre',
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 30, 30, 30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 55.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Enter OTP",
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: screenHeight * .01,
                        ),
                        Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(25, 36, 39, 96),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            maxLength: 6,
                            controller: _otp,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              counterText: '',
                              labelText: '', // Empty label text
                              hintText: 'Enter OTP', // Optional hint text
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                MainBtn(
                  width: 170,
                  fnc: () async {
                    await controller.verifyOTP(_otp.text);
                    if (controller.verified.value) {
                      // Verification is successful, proceed to the next screen
                      Get.toNamed('/signup/signup2/verification/profilepicture');
                    }

                    // await Authentication.loginUsingEmailPassword(
                    //   email: userData.email.toString(),
                    //   password: userData.password.toString(),
                    //   context: context,
                    // );
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         // GoalPage(userData: widget.userData),
                    //   ),
                    // );
                  },
                  title: "Verify",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
