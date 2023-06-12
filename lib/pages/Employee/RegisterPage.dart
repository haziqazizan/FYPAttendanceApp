// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hadeer_app/pages/model/employee.dart';

import '../loginpage.dart';
import 'Otp.dart';
import 'homeScreen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  double screenHeight = 0;
  double screenWidth = 0;

  TextEditingController userIdController = TextEditingController();
  TextEditingController pswdController = TextEditingController();
  TextEditingController pswdCfmController = TextEditingController();
  TextEditingController fulnameController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController phoneNumControler = TextEditingController();

  Color primary = const Color.fromARGB(255, 148, 215, 147);

  String? value;

  bool _obsecureText = true;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: (() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }),
          icon: const Icon(
            Icons.keyboard_arrow_left_rounded,
            color: Color.fromARGB(255, 52, 79, 51),
            size: 40,
          ),
        ),
        actions: [
          Container(
            padding: EdgeInsets.only(right: screenWidth / 14),
            child: Row(
              children: <Widget>[
                const Text(
                  "Already have an account ? ",
                  style: TextStyle(color: Colors.black54),
                ),
                GestureDetector(
                  child: const Text(
                    "Login",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10),
              height: screenHeight / 30,
              width: screenWidth,
            ),
            Container(
              margin: EdgeInsets.only(
                  top: screenHeight / 80, bottom: screenHeight / 20),
              child: Text(
                "Register",
                style: TextStyle(
                  fontSize: screenWidth / 9,
                  fontFamily: "NexaBold",
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(
                horizontal: screenWidth / 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  fieldTitle("Company Name"),
                  customField(
                    "Enter your Company Name",
                    companyNameController,
                    false,
                    const Icon(Icons.house_siding_rounded),
                  ),
                  fieldTitle("Full Name"),
                  customField(
                    "Enter your Full Name",
                    fulnameController,
                    false,
                    const Icon(Icons.person_outlined),
                  ),
                  fieldTitle("Phone Number"),
                  customField(
                    "Enter your Phone Number",
                    phoneNumControler,
                    false,
                    const Icon(Icons.phone_android_rounded),
                  ),
                  fieldTitle("User ID"),
                  customField(
                    "Enter your User ID",
                    userIdController,
                    false,
                    const Icon(Icons.person_pin_rounded),
                  ),
                  fieldTitle("Password"),
                  customField(
                    "Enter your Password",
                    pswdController,
                    true,
                    const Icon(Icons.key_rounded),
                  ),
                  fieldTitle("Confirmation Password"),
                  customField(
                    "Enter again your password",
                    pswdCfmController,
                    true,
                    const Icon(Icons.key_rounded),
                  ),
                  GestureDetector(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      String compName = companyNameController.text.trim();
                      String fname = fulnameController.text.trim();
                      String id = userIdController.text.trim();
                      String password = pswdController.text.trim();
                      String cfmPassword = pswdCfmController.text.trim();
                      String phnum = phoneNumControler.text.trim();

                      if (compName.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter your Company Name!"),
                          ),
                        );
                      } else if (fname.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter your Full Name!"),
                          ),
                        );
                      } else if (phnum.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter your Phone Number!"),
                          ),
                        );
                      } else if (id.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter your user ID!"),
                          ),
                        );
                      } else if (password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter your Password!"),
                          ),
                        );
                      } else if (cfmPassword.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter Again your password!"),
                          ),
                        );
                      } else if (cfmPassword != password) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Confirm Password is not matched"),
                          ),
                        );
                      } else {
                        if (phnum != null || password != null) {
                          await FirebaseFirestore.instance
                              .collection("Employee")
                              .doc(fname)
                              .set({
                            'Company Name': compName,
                            'FullName': fname,
                            'id': id,
                            'Phone Num': phnum,
                            'password': password,
                            'role': 'user'
                          }).then((value) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OtpVerification(),
                              ),
                            );
                          });
                        }
                      }
                    },
                    child: Container(
                      height: 60,
                      width: screenWidth,
                      margin: EdgeInsets.only(
                        top: screenHeight / 40,
                        bottom: screenHeight / 40,
                      ),
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(35),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Register",
                          style: TextStyle(
                            fontFamily: "NexaBold",
                            fontSize: screenWidth / 26,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget fieldTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: screenWidth / 26,
          fontFamily: "NexaBold",
        ),
      ),
    );
  }

  Widget customField(
    String hint,
    TextEditingController controller,
    bool obscure,
    Icon icon,
  ) {
    return Container(
      width: screenWidth,
      margin: EdgeInsets.only(bottom: screenHeight / 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(10, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: screenWidth / 6,
            child: icon,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: screenWidth / 12),
              child: TextFormField(
                controller: controller,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight / 35,
                  ),
                  border: InputBorder.none,
                  hintText: hint,
                ),
                maxLines: 1,
                obscureText: obscure,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
