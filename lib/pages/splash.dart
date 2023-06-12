import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadeer_app/pages/Employee/MenuPage.dart';
import 'package:hadeer_app/pages/Employer/menuEmp.dart';
import 'package:hadeer_app/pages/model/employee.dart';
import 'package:lottie/lottie.dart';

import 'Employee/homeScreen.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() {
    const duration = Duration(seconds: 4);
    Timer(duration, route);
  }

  void navigateNext(Widget route) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => route));
  }

  route() async {
    String role = Employee.role;

    if (role == 'user') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MenuPage()),
      );
    } else if (role == 'admin') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MenuEmp()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 148, 215, 147),
      body: content(),
    );
  }

  Widget content() {
    return Center(
      child: Container(
        child: Lottie.asset('assets/loadingSplash.json'),
      ),
    );
  }
}
