// ignore_for_file: invalid_use_of_protected_member

import 'package:csc_picker/csc_picker.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:fucare_android_studio/services/userdata.dart';
import 'package:fucare_android_studio/widget/title_main.dart';
import 'package:fucare_android_studio/widget/value_field.dart';
import 'package:get/get.dart';

// Main Controller SignupController that has all the values to enter in user detail-
// Gender,Class,Name,Dob,email,password,type,state/city
class SignupController extends GetxController {
  final selectedGender = '--Select--'.obs;
  final selectedClass = '10th'.obs;
  final selectedstate = ['', 'State', 'City'].obs;

  final firstName = TextEditingController().obs;
  final lastName = TextEditingController().obs;
  final dob = TextEditingController().obs;
  final email = TextEditingController().obs;
  final password = TextEditingController().obs;
  final confirmPassword = TextEditingController().obs;
  final isValid = true.obs;
  final isValidDOB = true.obs;
  final alreadyExist = true.obs;
  final typecontroller = TextEditingController().obs;
  final type = "User".obs;
  final linkedinUrl = TextEditingController().obs;
  final portfolioUrl = TextEditingController().obs;
  final bio = TextEditingController().obs;
  final workingAt = TextEditingController().obs;
  final designation = TextEditingController().obs;

  final userdatalist = <dynamic>[].obs;

  Future<void> fetchUserdatalist() async {
    final user = await DatabaseManager().getUserProfileList();
    userdatalist.value = user;
  }

  @override
  void onInit() {
    super.onInit();
    // Call the asynchronous function when the controller is initialized
    fetchUserdatalist();
  }
}

class EmailOTPController extends GetxController {
  final Rx<EmailOTP> _myauth = EmailOTP().obs;

  EmailOTP get myauth => _myauth.value;

  void sendOTP(String userEmail) async {
    final auth = myauth;

    auth.setConfig(
      appEmail: "utkarshsaxena@rediffmail.com",
      appName: "Email OTP",
      userEmail: userEmail.trim(),
      otpLength: 6,
      otpType: OTPType.digitsOnly,
    );
    final result = await auth.sendOTP();
    if (result) {
      Get.snackbar("OTP has been sent", "");
    } else {
      Get.snackbar("Oops, OTP send failed", "");
    }
  }
}

class SignupFormController extends GetxController {
  final signupController = Get.put(SignupController());
  final emailOTPController = Get.put(EmailOTPController());
  final databaseManager = DatabaseManager();

  void validateEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    signupController.isValid.value = emailRegExp.hasMatch(email);
  }

  void validateDOB(String dob) {
    final regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    signupController.isValidDOB.value = regex.hasMatch(dob);
  }

  void checkEmailExistence(String email) {
    final userdatalist = signupController.userdatalist;
    signupController.alreadyExist.value =
        userdatalist.any((user) => user['Email'] == email);
  }
}

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final SignupFormController controller = Get.put(SignupFormController());

  final SignupController signupController = Get.find();

  final EmailOTPController emailOTPController = Get.find();

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
            Padding(
              padding: EdgeInsets.only(top: screenHeight * .47),
              child: Padding(
                padding: const EdgeInsets.only(bottom: .0),
                child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/images/signUpBox.png'),
                    fit: BoxFit.cover,
                  )),
                  height: screenHeight * 1,
                ),
              ),
            ),

            // Title Name ---------------------------------------------------------
            Padding(
              padding: EdgeInsets.only(top: screenHeight * .05),
              child: const Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Welcome To",
                  style: TextStyle(
                    fontSize: 26,
                    fontFamily: 'AbhayaLibre',
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 30, 30, 30),
                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: screenHeight * .05),
                child:
                    const TitleMain(color: Color.fromARGB(255, 15, 121, 147))),

            Padding(
              padding: EdgeInsets.only(
                top: screenHeight * .22,
                left: 20,
                right: 20,
              ),
              child: SignupForm(
                controller: controller,
                signupController: signupController,
                emailOTPController: emailOTPController,
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
  final SignupController signupController;
  final EmailOTPController emailOTPController;
  final double screenHeight;
  final double screenWidht;

  const SignupForm({
    super.key,
    required this.controller,
    required this.signupController,
    required this.emailOTPController,
    required this.screenHeight,
    required this.screenWidht,
  });

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  String countryValue = "";
  String? stateValue = "";
  String? cityValue = "";
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          // ... Your form fields ...

          //Text 1 --------------------------------------------------------------------------------------------------
          const CustomText(title: 'First Name'),
          // Text Field 1 --------------------------------------------------------------------------------------------------
          ValueField(
            icon: Icons.person,
            controller: widget.signupController.firstName.value,
          ),
          SizedBox(
            height: widget.screenHeight * 0.01,
          ),
          //Text 2 --------------------------------------------------------------------------------------------------
          const CustomText(title: 'Last Name'),
          // Text Field 1 --------------------------------------------------------------------------------------------------
          ValueField(
            icon: Icons.person,
            controller: widget.signupController.lastName.value,
          ),
          SizedBox(
            height: widget.screenHeight * 0.01,
          ),

          //Text 3 --------------------------------------------------------------------------------------------------
          const CustomText(title: 'Date of Birth'),
          // Text Field 1 --------------------------------------------------------------------------------------------------
          ValueField(
            icon: Icons.calendar_month,
            controller: widget.signupController.dob.value,
            keyType: TextInputType.datetime,
            cond: true,
            labeltext: 'Enter DOB (dd/mm/yyyy)',
          ),
          SizedBox(
            height: widget.screenHeight * 0.01,
          ),

          //Text 4 --------------------------------------------------------------------------------------------------
          const CustomText(title: 'Gender'),
          // Text Field 1 --------------------------------------------------------------------------------------------------
          Obx(() {
            final selectedGender = widget.signupController.selectedGender.value;
            return Container(
              height: 50,
              width: double.infinity,
              decoration: const ShapeDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(103, 27, 26, 26),
                    Color.fromARGB(255, 255, 255, 255),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.1],
                  tileMode: TileMode.clamp,
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: DropdownButton<String>(
                  value: selectedGender,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  borderRadius: BorderRadius.circular(20),
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 0,
                    color: Colors.black, // Remove underline
                  ),
                  onChanged: (newValue) {
                    widget.signupController.selectedGender.value = newValue!;
                  },
                  items: <String>['--Select--', 'Male', 'Female', 'Other']
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.735,
                            child: Text(value),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          }),
          SizedBox(
            height: widget.screenHeight * 0.01,
          ),

          //Text 5 --------------------------------------------------------------------------------------------------
          const CustomText(title: 'Email'),
          // Text Field 1 --------------------------------------------------------------------------------------------------
          ValueField(
            icon: Icons.mail,
            controller: widget.signupController.email.value,
          ),
          SizedBox(
            height: widget.screenHeight * 0.01,
          ),

          //Text 6 --------------------------------------------------------------------------------------------------
          const CustomText(title: 'Password'),
          // Text Field 1 --------------------------------------------------------------------------------------------------
          ValueField(
            icon: Icons.lock,
            controller: widget.signupController.password.value,
          ),
          SizedBox(
            height: widget.screenHeight * 0.01,
          ),

          //Text 7 --------------------------------------------------------------------------------------------------
          const CustomText(title: 'Confirm Password'),
          // Text Field 1 --------------------------------------------------------------------------------------------------
          ValueField(
            icon: Icons.lock,
            controller: widget.signupController.confirmPassword.value,
          ),
          SizedBox(
            height: widget.screenHeight * 0.01,
          ),
          //Text 8 -
          const CustomText(title: 'Current Education'),

          Obx(() {
            final selectedClass = widget.signupController.selectedClass.value;
            return Container(
              height: 50,
              width: double.infinity,
              decoration: const ShapeDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(103, 27, 26, 26),
                    Color.fromARGB(255, 255, 255, 255),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.1],
                  tileMode: TileMode.clamp,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    side: BorderSide(width: 1, color: Colors.black)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: DropdownButton<String>(
                  value: selectedClass,
                  menuMaxHeight: 175,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  focusColor: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20),
                  iconDisabledColor: Colors.black,
                  underline: Container(
                    height: 0,
                    color: Colors.black, // Remove underline
                  ),
                  onChanged: (newValue) {
                    widget.signupController.selectedClass.value = newValue!;
                  },
                  items: <String>[
                    '10th',
                    '12th PCM',
                    '12th PCB',
                    '12th PCBM',
                    '12th Commerce',
                    '12th Arts',
                    'Under Graduate',
                  ]
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: SizedBox(
                              width: widget.screenWidht * .735,
                              child: Text(value)),
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          }),
          SizedBox(
            height: widget.screenHeight * 0.01,
          ),
          //Text 8 -
          const CustomText(title: 'Select Region'),
          //Dependency to Select state and city --------------------------------------------------------------------------------------------------
          CSCPicker(
            showStates: true,
            showCities: true,
            flagState: CountryFlag.DISABLE,
            dropdownDecoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                color: Colors.white,
                border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0), width: 1)),
            disabledDropdownDecoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                color: const Color.fromARGB(255, 234, 233, 233),
                border: Border.all(color: Colors.grey.shade300, width: 1)),
            countrySearchPlaceholder: "Country",
            stateSearchPlaceholder: "State",
            citySearchPlaceholder: "City",
            countryDropdownLabel: "Country",
            stateDropdownLabel: "State",
            cityDropdownLabel: "City",
            defaultCountry: CscCountry.India,
            countryFilter: const [
              CscCountry.India,
              CscCountry.United_States,
              CscCountry.Canada
            ],
            selectedItemStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            dropdownItemStyle:
                const TextStyle(color: Colors.black, fontSize: 15),
            dropdownHeadingStyle: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            dropdownDialogRadius: 20.0,
            searchBarRadius: 20.0,
            onCountryChanged: (value) {
              setState(() {
                countryValue = value;
                widget.controller.signupController.selectedstate.value[0] =
                    countryValue;
              });
            },
            onStateChanged: (value) {
              setState(() {
                stateValue = value;
                widget.controller.signupController.selectedstate.value[1] =
                    stateValue.toString();
              });
            },
            onCityChanged: (value) {
              setState(() {
                cityValue = value;
                widget.controller.signupController.selectedstate.value[2] =
                    cityValue.toString();
              });
            },
          ),

          //Text 9 --------------------------------------------------------------------------------------------------
          SizedBox(
            height: widget.screenHeight * 0.01,
          ),
          const CustomText(title: 'Referal Code'),
          // Text Field 1 --------------------------------------------------------------------------------------------------
          ValueField(
            icon: Icons.person,
            controller: widget.controller.signupController.typecontroller.value,
          ),

          // Text Field 1 --------------------------------------------------------------------------------------------------
          SizedBox(
            height: widget.screenHeight * 0.03,
          ),

          // Sign Up Button
          SizedBox(
            height: 50,
            width: 180,
            child: ElevatedButton(
              onPressed: () {
                String password = widget
                    .controller.signupController.password.value.text
                    .trim()
                    .toString();

                widget.controller.validateEmail(
                    widget.controller.signupController.email.value.text);
                widget.controller.validateDOB(
                    widget.controller.signupController.dob.value.text);
                widget.controller.checkEmailExistence(
                    widget.controller.signupController.email.value.text);
                if (widget.controller.signupController.typecontroller.value
                        .text ==
                    "#FuCare@0103") {
                  widget.controller.signupController.type.value = "Creator";
                } else {
                  widget.controller.signupController.type.value = "User";
                }

                if (widget.controller.signupController.firstName.value.text
                        .isEmpty ||
                    widget.controller.signupController.lastName.value.text
                        .isEmpty ||
                    widget
                        .controller.signupController.email.value.text.isEmpty ||
                    widget.controller.signupController.dob.value.text.isEmpty ||
                    widget
                        .controller.signupController.email.value.text.isEmpty) {
                  Get.snackbar("Enter Details", "");
                } else if (widget.controller.signupController.confirmPassword
                        .value.text !=
                    widget.controller.signupController.password.value.text) {
                  Get.snackbar("Enter same Password", "");
                } else if (!widget.controller.signupController.isValid.value) {
                  Get.snackbar("Enter correct email", "");
                } else if (widget
                        .controller.signupController.selectedGender.value ==
                    "--Select--") {
                  Get.snackbar("Select Gender", "");
                } else if (password.length < 7) {
                  Get.snackbar("Password length should be greater than 6", "");
                } else if (!widget
                    .controller.signupController.isValidDOB.value) {
                  Get.snackbar("Enter Date of Birth\nin correct format", "");
                } else if (widget
                    .controller.signupController.alreadyExist.value) {
                  Get.snackbar("Email already exist", "");
                } else if (widget.controller.signupController.selectedstate
                            .value[0] ==
                        "" ||
                    widget.controller.signupController.selectedstate
                            .value[1] ==
                        "State" ||
                    widget.controller.signupController.selectedstate.value[2] ==
                        "City" ||
                    widget.controller.signupController.selectedstate.value[2] ==
                        "null" ||
                    widget.controller.signupController.selectedstate.value[1] ==
                        "null") {
                  Get.snackbar("Select Region", "");
                } else {
                  Get.toNamed('/signup/signup2');
                }
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
