import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fucare_android_studio/services/auth_services.dart';
import 'package:fucare_android_studio/services/userdata.dart';
import 'package:get/get.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;
  bool _isNewUser = true;
  String email = '';
  List userdatalist = [];
  @override
  void initState() {
    super.initState();
    fetchUserDatabase();
  }

  void alreadyexist(String email) {
    for (int i = 0; i < userdatalist.length; i++) {
      if (userdatalist[i]['Email'] == email) {
        setState(() {
          _isNewUser = false;
        });
        break;
      } else {
        setState(() {
          _isNewUser = true;
        });
      }
    }
  }

  fetchUserDatabase() async {
    dynamic resultant = await DatabaseManager().getUserProfileList();

    if (resultant == null) {
      // print("Error in fetching data");
    } else {
      if (mounted) {
        setState(() {
          userdatalist = resultant;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: _isSigningIn
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 255, 255, 255)),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: TextButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(100, 50)),
                  side: MaterialStateProperty.all(
                    const BorderSide(
                      color: Colors.blue, // Change the border color here
                      width: 2, // Change the border width if needed
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () async {
                  setState(() {
                    _isSigningIn = true;
                  });

                  User? user =
                      await Authentication.signInWithGoogle(context: context);
                  email = user!.email!;
                  alreadyexist(email);
                  setState(() {
                    _isSigningIn = false;
                  });
                  _isNewUser
                      ? Get.toNamed('/signup')
                      : Get.offNamed('/main/home');
                },
                child: Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(right: 40),
                        child: Image.asset(
                          'assets/images/google.png',
                          scale: MediaQuery.of(context).size.height * .05,
                        )),
                    const Text(
                      'Sign in with Google',
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
