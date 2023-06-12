import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'empHist.dart';

class LeaveEmp extends StatelessWidget {
  final String sp, lv, ide;
  LeaveEmp({Key? key, required this.lv, required this.sp, required this.ide})
      : super(key: key);

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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Employee')
            .doc(sp)
            .collection(lv)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.black54,
                  fontFamily: 'NexaBold',
                ),
              ),
            );
          }

          final documents = snapshot.data!.docs;
          documents.sort((a, b) {
            final aStatus = a['Status'];
            final bStatus = b['Status'];

            if (aStatus == 'pending') {
              return -1; // "pending" comes before other statuses
            } else if (bStatus == 'pending') {
              return 1; // other statuses come after "pending"
            } else {
              return aStatus
                  .compareTo(bStatus); // sort by other statuses alphabetically
            }
          });

          if (documents.isEmpty) {
            return Center(
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
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final doc = documents[index];
              String dt = DateFormat('MMMMd').format(doc['subdate'].toDate());

              Color? statusColor;
              switch (doc['Status']) {
                case 'Pending':
                  statusColor = Colors.yellowAccent[400];
                  break;
                case 'Approved':
                  statusColor = Colors.green[200];
                  break;
                case 'Rejected':
                  statusColor = Colors.red;
                  break;
                default:
                  statusColor = null;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: statusColor,
                ),
                child: ListTile(
                  title: Text(
                    dt,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontFamily: 'NexaBold',
                    ),
                  ),
                  subtitle: Text(doc['Status']),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => empHist(
                          Emp: doc.id,
                          ide: ide,
                          dt: doc['subdate'],
                          dp: doc['ProofURL'],
                          sd: doc['Start'],
                          ed: doc['End'],
                          rl: doc['Reason'],
                          ls: doc['Status'],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
