import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadeer_app/pages/Employee/MenuPage.dart';
import 'package:hadeer_app/pages/Employer/EmployerHome.dart';
import 'package:hadeer_app/pages/Employer/menuEmp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Employee/RegisterPage.dart';
import 'Employee/forgotpassword.dart';
import 'Employee/homeScreen.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final _auth = FirebaseAuth.instance;

class _LoginPageState extends State<LoginPage> {
  TextEditingController userIdController = TextEditingController();
  TextEditingController pswdController = TextEditingController();

  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color.fromARGB(255, 148, 215, 147);
  late SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: (() {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          }),
          icon: const Icon(
            Icons.keyboard_arrow_left_rounded,
            color: Color.fromARGB(255, 52, 79, 51),
            size: 40,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20),
              height: screenHeight / 8,
              width: screenWidth,
            ),
            Container(
              margin: EdgeInsets.only(
                  top: screenHeight / 20, bottom: screenHeight / 20),
              child: Text(
                "Login",
                style: TextStyle(
                    fontSize: screenWidth / 9, fontFamily: "NexaBold"),
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
                  fieldTittle("User ID"),
                  customField("Enter your Use ID", userIdController, false,
                      const Icon(Icons.person_sharp)),
                  fieldTittle("Password"),
                  customField("Enter your Password", pswdController, true,
                      const Icon(Icons.key_rounded)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Dont have an Account ? "),
                      GestureDetector(
                        child: const Text(
                          "Register",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()));
                        },
                      ),
                    ],
                  ),

                  GestureDetector(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      String id = userIdController.text.trim();
                      String password = pswdController.text.trim();
                      if (id.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("User Id is still empty! "),
                        ));
                      } else if (password.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Password is still empty! "),
                        ));
                      } else {
                        CollectionReference collection;
                        if (id == 'admin') {
                          collection =
                              FirebaseFirestore.instance.collection('Admin');
                        } else {
                          collection =
                              FirebaseFirestore.instance.collection('Employee');
                        }

                        QuerySnapshot snap =
                            await collection.where('id', isEqualTo: id).get();

                        try {
                          if (snap.docs.isNotEmpty &&
                              password == snap.docs[0]['password']) {
                            String role = snap.docs[0]['role'];
                            sharedPreferences =
                                await SharedPreferences.getInstance();

                            sharedPreferences
                                .setString('userId', id)
                                .then((value) {
                              if (role == 'admin') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MenuEmp()),
                                );
                              } else if (role == 'user') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MenuPage()),
                                );
                              }
                            });
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Invalid credentials!"),
                            ));
                          }
                        } catch (e) {
                          String error = "Error occurred!";
                          print(e.toString());
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(error),
                          ));
                        }
                      }
                    },
                    child: Container(
                      height: 60,
                      width: screenWidth,
                      margin: EdgeInsets.only(top: screenHeight / 40),
                      decoration: BoxDecoration(
                          color: primary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(35))),
                      child: Center(
                        child: Text(
                          "Login",
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
                  const SizedBox(
                    height: 10,
                  ),
                  // Forgot Password GestureDetector
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordPage()));
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 200,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('Images/bgRegister.png'))),
            ),
          ],
        ),
      ),
    );
  }

  Widget fieldTittle(String tittle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Text(
        tittle,
        style: TextStyle(fontSize: screenWidth / 26, fontFamily: "NexaBold"),
      ),
    );
  }

  Widget customField(String hint, TextEditingController controller,
      bool obsecure, Icon Icons) {
    return Container(
      width: screenWidth,
      margin: EdgeInsets.only(bottom: screenHeight / 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
              color: Colors.black26, blurRadius: 10, offset: Offset(10, 10))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: screenWidth / 6,
            child: Icon(
              Icons.icon,
              size: screenWidth / 15,
              color: const Color.fromARGB(255, 52, 79, 51),
            ),
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
              obscureText: obsecure,
            ),
          ))
        ],
      ),
    );
  }
}
