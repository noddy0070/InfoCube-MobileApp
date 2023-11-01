import 'package:flutter/material.dart';
import "package:fucare_android_studio/services/auth_services.dart";
import "package:get/get.dart";

// ignore: must_be_immutable
class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static Text text(
      {required String text,
      double size = 20,
      FontWeight weight = FontWeight.normal}) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.black,
        fontFamily: "Inter",
        fontSize: size,
        fontWeight: weight,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  // ignore: unused_field
  bool _isSigningOut = false;
  double _height = 160;
  double _height2 = 0;
  double _height3 = 0;
  bool isTextVisible = false;
  bool isTextVisible2 = false;
  bool cond1 = true;
  bool cond2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 220, 229, 248),
        appBar: AppBar(
          toolbarHeight: 60,
          leading: IconButton(
            alignment: Alignment.centerRight,
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
              weight: 20,
              size: 30,
            ), // Replace with your desired icon
            onPressed: () {
              Get.back();
            },
          ),
          backgroundColor: const Color.fromARGB(255, 220, 229, 248),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 10, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text(
                  text: "Account",
                  size: 24,
                  weight: FontWeight.w600,
                ),
                const SizedBox(height: 10),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  height: _height,
                  curve: Curves.fastOutSlowIn,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(14, 36, 39, 96),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed("/main/profile/settings/editprofile");
                          },
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.black54,
                                  size: 30,
                                ),
                              ),
                              text(
                                  text: 'Edit Profile',
                                  size: 18,
                                  weight: FontWeight.w600),
                              const SizedBox(
                                width: 85,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Icon(
                                Icons.security_outlined,
                                color: Colors.black54,
                                size: 30,
                              ),
                            ),
                            text(
                                text: 'Security/Privacy',
                                size: 18,
                                weight: FontWeight.w600),
                            const SizedBox(
                              width: 85,
                            ),
                            IconButton(
                                icon: Icon(
                                  isTextVisible
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  color: Colors.black,
                                  weight: 50,
                                  size: 40,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (cond1) {
                                      _height = _height + 50.toDouble();
                                      _height2 = 50.toDouble();
                                      isTextVisible = true;
                                      cond1 = false;
                                    } else {
                                      _height = _height - 50.toDouble();
                                      _height2 = 0.toDouble();
                                      cond1 = true;
                                      isTextVisible = false;
                                    }
                                  });
                                })
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 90.0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: _height2,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: isTextVisible
                                        ? text(
                                            text: "Change Password",
                                            size: 16,
                                            weight: FontWeight.w600)
                                        : null,
                                  ),
                                  Container(
                                    child: isTextVisible
                                        ? text(
                                            text: 'Two Factor Authentication',
                                            size: 16,
                                            weight: FontWeight.w600)
                                        : null,
                                  )
                                ]),
                          ),
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Icon(
                                Icons.notifications_none_outlined,
                                color: Colors.black54,
                                size: 30,
                              ),
                            ),
                            text(
                                text: 'Notifications',
                                size: 18,
                                weight: FontWeight.w600),
                            const SizedBox(
                              width: 118,
                            ),
                            IconButton(
                                icon: Icon(
                                  isTextVisible2
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  color: Colors.black,
                                  weight: 50,
                                  size: 40,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (cond2) {
                                      _height = _height + 24.toDouble();
                                      _height3 = 24.toDouble();
                                      isTextVisible2 = true;
                                      cond2 = false;
                                    } else {
                                      _height = _height - 24.toDouble();
                                      _height3 = 0.toDouble();
                                      isTextVisible2 = false;
                                      cond2 = true;
                                    }
                                  });
                                })
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 90.0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: _height3,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: isTextVisible2
                                        ? text(
                                            text: "Pause All Notification",
                                            size: 16,
                                            weight: FontWeight.w600)
                                        : null,
                                  ),
                                ]),
                          ),
                        ),
                      ]),
                ),
                const SizedBox(height: 10),
                text(
                  text: "Support",
                  size: 24,
                  weight: FontWeight.w600,
                ),
                const SizedBox(height: 10),
                //Support
                Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(14, 36, 39, 96),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Icon(
                                Icons.credit_card,
                                color: Colors.black54,
                                size: 30,
                              ),
                            ),
                            text(
                                text: 'My Subscribtion',
                                size: 18,
                                weight: FontWeight.w600),
                            const SizedBox(
                              width: 85,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Icon(
                                Icons.help_outline,
                                color: Colors.black54,
                                size: 30,
                              ),
                            ),
                            text(
                                text: 'Help & Support',
                                size: 18,
                                weight: FontWeight.w600),
                            const SizedBox(
                              width: 85,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Icon(
                                Icons.info_outline,
                                color: Colors.black54,
                                size: 30,
                              ),
                            ),
                            text(
                                text: 'Terms and Policies',
                                size: 18,
                                weight: FontWeight.w600),
                            const SizedBox(
                              width: 85,
                            ),
                          ],
                        ),
                      ]),
                ),
                const SizedBox(height: 10),
                text(
                  text: "Theme",
                  size: 24,
                  weight: FontWeight.w600,
                ),
                const SizedBox(height: 10),
                //Support
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(14, 36, 39, 96),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Icon(
                                Icons.circle,
                                color: Colors.black54,
                                size: 30,
                              ),
                            ),
                            text(
                                text: 'Dark Mode',
                                size: 18,
                                weight: FontWeight.w600),
                            const SizedBox(
                              width: 85,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Icon(
                                Icons.circle,
                                color: Color.fromARGB(252, 255, 255, 255),
                                size: 30,
                              ),
                            ),
                            text(
                                text: 'Light Theme',
                                size: 18,
                                weight: FontWeight.w600),
                            const SizedBox(
                              width: 85,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ]),
                ),
                const SizedBox(height: 10),
                text(
                  text: "Actions",
                  size: 24,
                  weight: FontWeight.w600,
                ),
                const SizedBox(height: 10),
                //Support
                Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(14, 36, 39, 96),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Icon(
                                Icons.flag_outlined,
                                color: Colors.black54,
                                size: 30,
                              ),
                            ),
                            text(
                                text: 'Report a Problem',
                                size: 18,
                                weight: FontWeight.w600),
                            const SizedBox(
                              width: 85,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Icon(
                                Icons.info,
                                color: Colors.black54,
                                size: 30,
                              ),
                            ),
                            text(
                                text: 'About Us',
                                size: 18,
                                weight: FontWeight.w600),
                            const SizedBox(
                              width: 85,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              _isSigningOut = true;
                            });
                            await Authentication.signOut(context: context);
                            setState(() {
                              _isSigningOut = false;
                            });
                            Get.offAllNamed('/');
                          },
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Icon(
                                  Icons.logout,
                                  color: Colors.black54,
                                  size: 30,
                                ),
                              ),
                              text(
                                  text: 'Log Out',
                                  size: 18,
                                  weight: FontWeight.w600),
                              const SizedBox(
                                width: 85,
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ));
  }
}
