// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fucare_android_studio/services/auth_services.dart';
import 'package:fucare_android_studio/services/google_sign_in.dart';
import 'package:fucare_android_studio/services/sign_btn.dart';
import 'package:fucare_android_studio/widget/title_main.dart';
import 'package:fucare_android_studio/widget/value_field.dart';
import 'package:get/get.dart';

// Login Controller contains the email and password entered by the user
class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RxBool passwordVisible = true.obs;
  // ignore: unused_field
  final bool _isSigningIn = false;
  Future<void> signIn() async {
    // Add your sign-in logic here
  }
}

class Login extends StatelessWidget {
  Login({super.key});
  final LoginController controller =
      Get.put(LoginController()); // Initialize the controller

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidht = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 229, 248),
      body: SingleChildScrollView(
        child: GetBuilder<LoginController>(builder: (loginController) {
          return Stack(
            children: [
              Container(
                // Background image --------------------------------------------------------------------------------------------------//
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/loginPageBox.png'),
                        fit: BoxFit.cover)),
                height: screenHeight * 0.75,
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    // Title Name --------------------------------------------------------------------------------------------------
                    const TitleMain(color: Colors.white),
                    SizedBox(
                      height: screenHeight * .27,
                    ),
                    // Quote --------------------------------------------------------------------------------------------------
                    const Text(
                      "Talent Knows No Boundaries \nGet The Opportunities You Deserve",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Jua",
                          color: Color.fromARGB(255, 98, 95, 30),
                          height: 1.2),
                      textAlign: TextAlign.center,
                    ),
                    // Gap --------------------------------------------------------------------------------------------------
                    SizedBox(
                      height: screenHeight * .01,
                    ),

                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            //Text 1 --------------------------------------------------------------------------------------------------
                            const CustomText(title: "Email"),
                            // Text Field 1 --------------------------------------------------------------------------------------------------
                            ValueField(
                              icon: Icons.email,
                              keyType: TextInputType.emailAddress,
                              controller: controller.emailController,
                            ),

                            //Text 2 --------------------------------------------------------------------------------------------------
                            const CustomText(title: "Password"),
                            // Text Field 2 for password --------------------------------------------------------------------------------------------------
                            Obx(() {
                              bool hidetext =
                                  loginController.passwordVisible.value;
                              return Container(
                                height: 50,
                                decoration: const ShapeDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(103, 27, 26, 26),
                                      Color.fromARGB(255, 255, 255, 255)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.0, .1],
                                    tileMode: TileMode.clamp,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                ),
                                child: TextField(
                                  controller: controller.passwordController,
                                  expands: false,
                                  obscureText: hidetext,
                                  style: const TextStyle(
                                      fontSize: 20.0, color: Colors.black54),
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                          loginController.passwordVisible.value
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                      onPressed: () {
                                        loginController.passwordVisible.value =
                                            !loginController
                                                .passwordVisible.value;
                                      },
                                    ),
                                    contentPadding: const EdgeInsets.all(12.0),
                                    prefixIcon:const Icon(
                                      Icons.lock,
                                      color:  Color.fromARGB(200, 0, 0, 0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(161, 8, 8, 8)),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              160, 106, 105, 105)),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                              );
                            }),

                            // Forgot Password --------------------------------------------------------------------------------------------------
                            Align(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                    onTap: () {
                                      Get.toNamed('/forgotpassword');
                                    },
                                    child: const Text(
                                      'Forgot Password',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromARGB(255, 8, 117, 144),
                                          decoration: TextDecoration.underline,
                                          decorationColor:
                                              Color.fromARGB(255, 8, 117, 144)),
                                    ))),
                          ],
                        )),

                    //Gap --------------------------------------------------------------------------------------------------
                    SizedBox(
                      height: screenHeight * .02,
                    ),

                    // Sign In Button --------------------------------------------------------------------------------------------------
                    FutureBuilder(
                      future:
                          Authentication.initializeFirebase(context: context),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Error initializing Firebase');
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          return SignInButton(
                              emailController: controller.emailController,
                              passwordController:
                                  controller.passwordController);
                        }
                        return const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 0, 0, 0)),
                        );
                      },
                    ),

                    //Text3 --------------------------------------------------------------------------------------------------
                    Padding(
                      padding: EdgeInsets.only(
                          top: screenHeight * 0.01, left: screenWidht * 0.27),
                      child: Row(
                        children: [
                          const Text(
                            'New to FuCare? ',
                            style: TextStyle(fontSize: 16),
                          ),
                          GestureDetector(
                              onTap: () {
                                Get.toNamed('/signup');
                              },
                              child: const Text(
                                'Sign up',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 8, 117, 144),
                                    decoration: TextDecoration.underline,
                                    decorationColor:
                                        Color.fromARGB(255, 8, 117, 144)),
                              )),
                        ],
                      ),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            const Text(
                              'Or',
                              style: TextStyle(
                                  fontSize: 18,
                                  decoration: TextDecoration.underline),
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            FutureBuilder(
                              future: Authentication.initializeFirebase(
                                  context: context),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text(
                                      'Error initializing Firebase');
                                } else if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return const GoogleSignInButton();
                                }
                                return const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color.fromARGB(255, 0, 0, 0)),
                                );
                              },
                            )
                          ],
                        ))
                  ],
                ),
              ),
              // Vector Image --------------------------------------------------------------------------------------------------
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.11),
                  child: SizedBox(
                      height: .32 * screenHeight,
                      child: Image.asset('assets/images/loginPageImg.png')),
                ),
              ),

              // Lines --------------------------------------------------------------------------------------------------
              Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.405),
                  child: Image.asset(
                    'assets/images/lines.png',
                    scale: .5,
                  )),
            ],
          );
        }),
      ),
    );
  }
}

Future<void> navigate(BuildContext context, String route,
        {bool isDialog = false,
        bool isRootNavigator = true,
        Map<String, dynamic>? arguments}) =>
    Navigator.of(context, rootNavigator: isRootNavigator)
        .pushNamed(route, arguments: arguments);
