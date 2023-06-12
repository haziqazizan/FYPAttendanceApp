import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadeer_app/pages/Employee/History.dart';
import 'package:hadeer_app/pages/Employee/attendance.dart';
import 'package:hadeer_app/pages/Employer/empLeave.dart';

import '../Employee/leaveHist.dart';
import '../model/employee.dart';
import 'empAtt.dart';

class empDetails extends StatelessWidget {
  final String ep, fn, pn, sub, sub1, ide;
  empDetails(
      {Key? key,
      required this.ep,
      required this.ide,
      required this.fn,
      required this.pn,
      required this.sub,
      required this.sub1})
      : super(key: key);

  double screenHeight = 0;
  double screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    Color primary = const Color.fromARGB(255, 79, 120, 78);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primary,
          title: Text(fn),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: const BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage('Images/emp.png'))),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Details",
                style: TextStyle(
                  fontFamily: "NexaBold",
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 65)),
                    const Text(
                      "Full Name",
                      style: TextStyle(
                          fontFamily: "NexaRegular",
                          // fontSize: screenWidth / 20,
                          color: Colors.black54),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      fn,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontFamily: "NexaBold",
                        //  fontSize: screenWidth / 18,
                      ),
                    ),
                  ]),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(padding: EdgeInsets.only(left: 65)),
                  const Text(
                    "Phone Number",
                    style: TextStyle(
                        fontFamily: "NexaRegular",
                        // fontSize: screenWidth / 20,
                        color: Colors.black54),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    pn,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 54, 75, 55),
                      fontFamily: "NexaBold",
                      //  fontSize: screenWidth / 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LeaveEmp(sp: ep, lv: sub, ide: ide)));
                    },
                    child: Container(
                      height: 60,
                      width: screenWidth / 2.8,
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                          color: Colors.orangeAccent[400],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(35))),
                      child: Center(
                        child: Text(
                          "Leave History",
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
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EmpAttendance(sp: ep, lv: sub1, fn: fn)));
                    },
                    child: Container(
                      height: 60,
                      width: screenWidth / 2.8,
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                          color: Colors.orangeAccent[400],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(35))),
                      child: Center(
                        child: Text(
                          "Attendance ",
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
                    width: 10,
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
