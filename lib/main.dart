import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:fucare_android_studio/Pages/profile_edit.dart';
import 'package:fucare_android_studio/Pages/field_of_interest.dart';
import 'package:fucare_android_studio/Pages/forgot_password.dart';
import 'package:fucare_android_studio/Pages/goal.dart';
import 'package:fucare_android_studio/Pages/login.dart';
import 'package:fucare_android_studio/Pages/profilepicture.dart';
import 'package:fucare_android_studio/Pages/selectedcontent.dart';
import 'package:fucare_android_studio/Pages/settings.dart';
import 'package:fucare_android_studio/Pages/signup.dart';
import 'package:fucare_android_studio/Pages/signup2.dart';
import 'package:fucare_android_studio/Pages/verification.dart';
import 'package:fucare_android_studio/Pages/navbar.dart';
import 'package:get/get.dart';

//
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

/// removing status bar
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => Login()),
        GetPage(name: '/signup', page: () => const Signup()),
        GetPage(
          name: '/signup/signup2',
          page: () => const Signup2(),
        ),
        GetPage(name: '/forgotpassword', page: () => const ForgotPassword()),
        GetPage(
          name: '/signup/signup2/verification',
          page: () => Verification(),
        ),
        GetPage(
            name: '/signup/signup2/verification/profilepicture',
            page: () => const ProfilePicturePage()),
        GetPage(
            name: '/signup/signup2/verification/profilepicture/goal',
            page: () => GoalPage()),
        GetPage(
          name: '/signup/signup2/verification/profilepicture/goal/foi',
          page: () => FOIpage(),
        ),
        GetPage(name: '/main/home', page: () => const NavigationBarPage()),
        GetPage(
            name: '/main/content/field', page: () => const ContentSelected()),
        GetPage(name: '/main/profile/settings', page: () => const Settings()),
        GetPage(
            name: '/main/profile/settings/editprofile',
            page: () => const ProfileEdit())
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 220, 229, 248),
          background: const Color(0xFFDCE5F8),
        ),
        useMaterial3: true,
      ),
      home: const First(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class First extends StatefulWidget {
  const First({Key? key}) : super(key: key);

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: _initializeFirebase(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("can't initialize firebase");
              } else if (snapshot.connectionState == ConnectionState.done) {
                return Login();
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
