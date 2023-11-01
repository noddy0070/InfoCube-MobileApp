// ignore_for_file: use_build_context_synchronously

import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';

import 'package:fucare_android_studio/widget/buttons.dart';
import 'package:fucare_android_studio/widget/title_main.dart';
import 'package:fucare_android_studio/widget/value_field.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _otp = TextEditingController();
  var verified = false;
  EmailOTP myauth = EmailOTP();

  void sendOTP() async {
    myauth.setConfig(
        appEmail: "utkarshsaxena@rediffmail.com",
        appName: "Email OTP",
        userEmail: _email.text,
        otpLength: 6,
        otpType: OTPType.digitsOnly);
    if (await myauth.sendOTP() == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("OTP has been sent"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Oops, OTP send failed"),
      ));
    }
  }

  void verifyOTP() async {
    if (await myauth.verifyOTP(otp: _otp.text) == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("OTP is verified"),
      ));
      verified = true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid OTP"),
      ));
      verified = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 220, 229, 248),
        body: SingleChildScrollView(
          child: Stack(children: [
            Container(
              // Background image //
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/forgotpasswordBox.png'),
                      fit: BoxFit.cover)),
              height: screenHeight * 1,
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * .09),
              child: const Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Welcome To",
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'AbhayaLibre',
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 30, 30, 30),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * .1),
              child: const TitleMain(
                color: Color.fromARGB(255, 15, 121, 147),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight * .27,
                  ),
                  const CustomText(title: "Email"),
                  ValueField(
                    icon: Icons.mail,
                    controller: _email,
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  const CustomText(title: "New Password"),
                  ValueField(
                      icon: Icons.lock, controller: _newPassword, ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  const CustomText(title: "Confrim Password"),
                  ValueField(
                      icon: Icons.lock,
                      controller: _confirmPassword,
                      ),
                  SizedBox(
                    height: screenHeight * 0.015,
                  ),
                  Column(
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
                          width: 140,
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
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MainBtn(
                          width: 160,
                          fnc: () {
                            verifyOTP();
                            if (verified) {
                              Navigator.pop(context);
                            }
                          },
                          title: "Verify"),
                      const SizedBox(
                        width: 20,
                      ),
                      MainBtn(
                          width: 160,
                          fnc: () {
                            sendOTP();
                          },
                          title: "Send OTP"),
                    ],
                  ),
                ],
              ),
            )
          ]),
        ));
  }
}
