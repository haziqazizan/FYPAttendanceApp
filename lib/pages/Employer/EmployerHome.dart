import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Employee/History.dart';
import '../Employee/attendance.dart';
import '../Employee/homeScreen.dart';
import '../Employee/leave.dart';
import '../model/employee.dart';

class EmpHome extends StatefulWidget {
  const EmpHome({Key? key}) : super(key: key);

  @override
  State<EmpHome> createState() => _EmpHomeState();
}

class _EmpHomeState extends State<EmpHome> {
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color.fromARGB(255, 148, 215, 147);
  late SharedPreferences sharedPreferences;
  bool userAvailable = false;

  int currentIndex = 1;

  @override
  void initState() {
    super.initState();
    getId();
  }

  void getId() async {
    QuerySnapshot sp = await FirebaseFirestore.instance
        .collection("Employee")
        .where('id', isEqualTo: Employee.userID)
        .get();

    setState(() {
      Employee.user = sp.docs[0].id;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 32),
            child: Text(
              "Welcome",
              style: TextStyle(
                color: Colors.black54,
                fontFamily: "NexaRegular",
                fontSize: screenWidth / 20,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              Employee.userID,
              style: TextStyle(
                fontFamily: "NexaBold",
                fontSize: screenWidth / 18,
              ),
            ),
          ),
          const Center(
            child: Text('this is admin page'),
          )
        ]),
      ),
    );
  }
}
