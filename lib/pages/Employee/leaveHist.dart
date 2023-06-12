import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadeer_app/pages/Employee/histDetails.dart';
import 'package:intl/intl.dart';
import '../model/employee.dart';

class LeaveHist extends StatefulWidget {
  const LeaveHist({Key? key}) : super(key: key);

  @override
  State<LeaveHist> createState() => _LeaveHistState();
}

class _LeaveHistState extends State<LeaveHist> {
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color.fromARGB(255, 79, 120, 78);

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text('Leave History'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 30),
        child: SizedBox(
          height: screenHeight / 1.5,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Employee")
                .doc(Employee.user)
                .collection("Leave")
                .orderBy('subdate', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                final snap = snapshot.data!.docs;

                snap.sort((a, b) {
                  String statusA = a['Status'];
                  String statusB = b['Status'];

                  if (statusA == 'pending') {
                    return -1; // "pending" comes before other statuses
                  } else if (statusB == 'pending') {
                    return 1; // other statuses come after "pending"
                  } else {
                    return statusA.compareTo(
                        statusB); // sort by other statuses alphabetically
                  }
                });

                if (snap.isEmpty) {
                  return const Center(
                    child: Text(
                      'No Leave submission has been made',
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'NexaBold',
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: snap.length,
                  itemBuilder: (context, index) {
                    String dt = DateFormat('MMMMd')
                        .format(snap[index]['subdate'].toDate());

                    Color? containerColor;
                    switch (snap[index]['Status']) {
                      case 'pending':
                        containerColor = Colors.yellow;
                        break;
                      case 'Accepted':
                        containerColor = Colors.lightGreen[200];
                        break;
                      case 'Rejected':
                        containerColor = Colors.red;
                        break;
                      default:
                        containerColor = Colors.lightGreen[200];
                        break;
                    }

                    return Container(
                      margin: const EdgeInsets.only(
                          bottom: 20, left: 10, right: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: containerColor),
                      child: ListTile(
                        title: Text(
                          dt,
                          style: const TextStyle(
                              color: Colors.black54, fontFamily: "NexaBold"),
                        ),
                        subtitle: Text(snap[index]['Status']),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HistDetails(
                              dt: snap[index]['subdate'],
                              dp: snap[index]['ProofURL'],
                              sd: snap[index]['Start'],
                              ed: snap[index]['End'],
                              rl: snap[index]['Reason'],
                              ls: snap[index]['Status'],
                            ),
                          ));
                        },
                      ),
                    );
                  },
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}
