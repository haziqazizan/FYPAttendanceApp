import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadeer_app/pages/model/employee.dart';
import 'package:intl/intl.dart';

class HistDetails extends StatelessWidget {
  final Timestamp dt, sd, ed;
  final String dp, rl, ls;

  const HistDetails({
    Key? key,
    required this.dt,
    required this.dp,
    required this.sd,
    required this.ed,
    required this.rl,
    required this.ls,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color primary = const Color.fromARGB(255, 79, 120, 78);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(DateFormat('MMMMd').format(dt.toDate())),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Employee")
              .doc(Employee.user)
              .collection("Leave")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              DateTime ed1 = DateTime.parse(ed.toDate().toString());
              DateTime sd1 = DateTime.parse(sd.toDate().toString());
              final diffdate = ed1.difference(sd1).inDays;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    dp.toString(),
                    height: 300,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Details",
                    style: TextStyle(
                      fontFamily: "NexaBold",
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Start",
                            style: TextStyle(
                              fontFamily: "NexaRegular",
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            DateFormat('MMMMd').format(sd.toDate()),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontFamily: "NexaBold",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 150),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "End",
                            style: TextStyle(
                              fontFamily: "NexaRegular",
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            DateFormat('MMMMd').format(ed.toDate()),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 54, 75, 55),
                              fontFamily: "NexaBold",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 65)),
                      Text(
                        "Duration",
                        style: TextStyle(
                          fontFamily: "NexaRegular",
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        diffdate.toString(),
                        style: const TextStyle(
                          color: Color.fromARGB(255, 54, 75, 55),
                          fontFamily: "NexaBold",
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Days",
                        style: TextStyle(
                          color: Color.fromARGB(255, 54, 75, 55),
                          fontFamily: "NexaBold",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 65)),
                      Text(
                        "Reasons",
                        style: TextStyle(
                          fontFamily: "NexaRegular",
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        rl,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 54, 75, 55),
                          fontFamily: "NexaBold",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 65)),
                      Text(
                        "Status",
                        style: TextStyle(
                          fontFamily: "NexaRegular",
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        ls,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 54, 75, 55),
                          fontFamily: "NexaBold",
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return const CircularProgressIndicator(); // Show a loading indicator when data is being fetched
            }
          },
        ),
      ),
    );
  }
}
