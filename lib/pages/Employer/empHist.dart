import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadeer_app/pages/model/employee.dart';
import 'package:intl/intl.dart';

class empHist extends StatelessWidget {
  final Timestamp dt, sd, ed;
  final String dp, rl, ls, Emp, ide;
  const empHist({
    Key? key,
    required this.Emp,
    required this.ide,
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
              .doc(Emp)
              .collection("Leave")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              DateTime ed1 = DateTime.parse(ed.toDate().toString());
              DateTime sd1 = DateTime.parse(sd.toDate().toString());
              final diffdate = ed1.difference(sd1).inDays;

              return Column(
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
                          const Text(
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
                          )
                        ],
                      ),
                      const SizedBox(width: 150),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
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
                          )
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
                      const Text(
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
                      const Text(
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
                      const Text(
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
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 65)),
                      const Text(
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
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 65)),
                      GestureDetector(
                        onTap: () async {
                          if (ls != 'Approved') {
                            // Show confirmation dialog
                            bool confirm = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirm Approval'),
                                  content: const Text(
                                      'Are you sure you want to approve this leave request?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Approve'),
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );

                            // Proceed with approval if confirmed
                            if (confirm == true) {
                              QuerySnapshot snap = await FirebaseFirestore
                                  .instance
                                  .collection("Employee")
                                  .where('id', isEqualTo: ide)
                                  .get();

                              await FirebaseFirestore.instance
                                  .collection("Employee")
                                  .doc(snap.docs[0].id)
                                  .collection("Leave")
                                  .doc(Emp)
                                  .update({'Status': 'Approved'});

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Leave request approved.'),
                              ));
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            color: ls != 'Approved' ? primary : Colors.grey,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            "Approve",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "NexaBold",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      GestureDetector(
                        onTap: () async {
                          if (ls != 'Rejected') {
                            // Show confirmation dialog
                            bool confirm = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirm Rejection'),
                                  content: const Text(
                                      'Are you sure you want to reject this leave request?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Reject'),
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );

                            // Proceed with rejection if confirmed
                            if (confirm == true) {
                              QuerySnapshot snap = await FirebaseFirestore
                                  .instance
                                  .collection("Employee")
                                  .where('id', isEqualTo: ide)
                                  .get();

                              await FirebaseFirestore.instance
                                  .collection("Employee")
                                  .doc(snap.docs[0].id)
                                  .collection("Leave")
                                  .doc(Emp)
                                  .update({'Status': 'Rejected'});

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Leave request rejected.'),
                              ));
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            color: ls != 'Rejected'
                                ? Colors.red[300]
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            "Reject",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "NexaBold",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
