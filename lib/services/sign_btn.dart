// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fucare_android_studio/services/auth_services.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  final RxBool isSigningIn = false.obs;

  Future<void> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    isSigningIn.value = true;
    // Call your authentication method here and handle the sign-in logic
    // Replace the logic below with your actual sign-in code
    await Future.delayed(const Duration(seconds: 2));
    User? user = await Authentication.loginUsingEmailPassword(
        email: email, password: password, context: context);
    // Simulate successful sign-in
    isSigningIn.value = false;
    if (user != null) {
      Get.offAllNamed('/main/home');
    }
  }
}

class SignInButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  SignInButton({
    Key? key,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  final SignInController signInController = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Obx(() {
        return signInController.isSigningIn.value
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 255, 255, 255),
                ),
              )
            : SizedBox(
                height: 50,
                width: 800,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: ElevatedButton(
                    onPressed: () {
                      signInController.signIn(
                        email: emailController.text,
                        password: passwordController.text,
                        context: context,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 25,
                      shadowColor: const Color.fromARGB(255, 0, 0, 0),
                      backgroundColor: const Color.fromARGB(255, 222, 97, 97),
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
      }),
    );
  }
}
