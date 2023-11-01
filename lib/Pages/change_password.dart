import 'package:flutter/material.dart';

import 'package:fucare_android_studio/widget/title_main.dart';
import 'package:fucare_android_studio/widget/value_field.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 220, 229, 248),
        body: Stack(children: [
          Container(
            // Background image----------------------------------------------------------------
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/forgotpasswordBox.png'),
                    fit: BoxFit.cover)),
            height: screenHeight * 1.5,
          ),

          // Welcom Text----------------------------------------------------------------
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

          //Title Main ----------------------------------------------------------------
          Padding(
            padding: EdgeInsets.only(top: screenHeight * .1),
            child: const TitleMain(
              color: Color.fromARGB(255, 15, 121, 147),
            ),
          ),

          // Main Buttons ----------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight * .4,
                ),
                // Old Password
                const CustomText(title: "Old Password"),
                ValueField(
                  icon: Icons.lock,
                  controller: _email,
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),

                // New Password
                const CustomText(title: "New Password"),
                ValueField(
                  icon: Icons.lock,
                  controller: _newPassword,
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),

                //Confirm Password 
                const CustomText(title: "Confrim Password"),
                ValueField(
                  icon: Icons.lock,
                  controller: _confirmPassword,
                ),
                const SizedBox(
                  height: 50,
                ),

                // Verify Button 
                SizedBox(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          elevation: 25,
                          shadowColor: const Color.fromARGB(255, 0, 0, 0),
                          backgroundColor:
                              const Color.fromARGB(255, 227, 117, 117),
                        ),
                        child: const Text(
                          'Verify',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ))),
              ],
            ),
          )
        ]));
  }
}
