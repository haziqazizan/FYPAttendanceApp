import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hadeer_app/pages/Employee/leaveHist.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../model/employee.dart';

class Leave extends StatefulWidget {
  const Leave({Key? key}) : super(key: key);

  @override
  State<Leave> createState() => _LeaveState();
}

class _LeaveState extends State<Leave> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  final ValueNotifier<String> reason = ValueNotifier<String>('Reason');
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = const Color.fromARGB(255, 79, 120, 78);

  int remainingLeave = 7; // Total number of leave
  bool isSubmitEnabled = true; // Enable submit button by default

  bool showOptionalLeaveDetails = false;
  TextEditingController optionalLeaveDetailsController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final start = dateRange.start;
    final end = dateRange.end;
    final difference = dateRange.duration;

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    Future uploadFile() async {
      final path = 'Proof/${pickedFile!.name}';
      final file = File(pickedFile!.path!);
      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);
      final snapshot = await uploadTask!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
    }

    Future selectFile() async {
      final file = await FilePicker.platform.pickFiles();
      if (file == null) return;
      setState(() {
        pickedFile = file.files.first;
      });
    }

    Future pickDateRange() async {
      DateTimeRange? newDateRange = await showDateRangePicker(
        context: context,
        initialDateRange: dateRange,
        firstDate: DateTime(2022),
        lastDate: DateTime(2099),
      );
      if (newDateRange == null) return;
      setState(() => dateRange = newDateRange);
    }

    void showSuccessMessage() {
      Fluttertoast.showToast(
        msg: "Leave submitted successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 50, bottom: 30),
              child: Text(
                "Apply Leave",
                style: TextStyle(
                  color: Colors.black87,
                  fontFamily: "Nexabold",
                  fontSize: screenWidth / 18,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Date",
                          style: TextStyle(
                            fontFamily: "NexaRegular",
                            fontSize: screenWidth / 20,
                            color: Colors.black54,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 5,
                                  ),
                                  onPressed: pickDateRange,
                                  child: Text(
                                    '${start.year}/${start.month}/${start.day}',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 5,
                                  ),
                                  onPressed: pickDateRange,
                                  child: Text(
                                    '${end.year}/${end.month}/${end.day}',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(18),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: reason.value,
                items: const [
                  DropdownMenuItem(
                    value: "Reason",
                    child: Text("Reason"),
                  ),
                  DropdownMenuItem(
                    value: "Medical Leave",
                    child: Text("Sick Leave"),
                  ),
                  DropdownMenuItem(
                    value: "Annual Leave",
                    child: Text("Paid Leave"),
                  ),
                  DropdownMenuItem(
                    value: "Maternity Leave",
                    child: Text("Maternity Leave"),
                  ),
                  DropdownMenuItem(
                    value: "Optional Leave",
                    child: Text("Optional Leave"),
                  ),
                ],
                onChanged: (value) {
                  reason.value = value!;
                  if (value == 'Optional Leave') {
                    setState(() {
                      showOptionalLeaveDetails = true;
                    });
                  } else {
                    setState(() {
                      showOptionalLeaveDetails = false;
                    });
                  }
                },
              ),
            ),
            if (showOptionalLeaveDetails)
              Container(
                padding: const EdgeInsets.all(18),
                child: TextFormField(
                  controller: optionalLeaveDetailsController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Optional Leave Details',
                  ),
                ),
              ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  child: ElevatedButton(
                    onPressed: selectFile,
                    child: const Icon(Icons.upload_file),
                  ),
                ),
                if (pickedFile != null)
                  Expanded(
                    child: Container(
                      color: Colors.grey[400],
                      child: Center(
                        child: Text(pickedFile!.name),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (remainingLeave > 0) {
                      uploadFile();
                      final snapshot = await uploadTask!.whenComplete(() {});
                      final urlDownload = await snapshot.ref.getDownloadURL();
                      QuerySnapshot snap = await FirebaseFirestore.instance
                          .collection("Employee")
                          .where('id', isEqualTo: Employee.userID)
                          .get();
                      await FirebaseFirestore.instance
                          .collection("Employee")
                          .doc(snap.docs[0].id)
                          .collection("Leave")
                          .doc(
                              DateFormat('dd MMMM yyyy').format(DateTime.now()))
                          .set({
                        'startDate': start,
                        'endDate': end,
                        'leaveType': reason.value,
                        'optionalLeaveDetails':
                            optionalLeaveDetailsController.text,
                        'proofUrl': urlDownload,
                        'status': 'pending',
                        'timestamp': DateTime.now(),
                      });

                      remainingLeave--; // Decrease the remaining leave count
                      if (remainingLeave == 0) {
                        isSubmitEnabled =
                            false; // Disable submit button when no leave remaining
                      }

                      optionalLeaveDetailsController.clear();
                      pickedFile = null;
                      reason.value = 'Reason';
                      dateRange = DateTimeRange(
                        start: DateTime.now(),
                        end: DateTime.now(),
                      );

                      showSuccessMessage();
                    } else {
                      Fluttertoast.showToast(
                        msg: "No more leaves available",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                  child: Container(
                    width: 150,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: remainingLeave > 0 ? primary : Colors.grey[400],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        fontFamily: "NexaRegular",
                        fontSize: screenWidth / 26,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LeaveHist(),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    height: 50,
                    width: 150,
                    decoration: const BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(35),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Leave History",
                        style: TextStyle(
                          fontFamily: "NexaBold",
                          fontSize: screenWidth / 28,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: primary,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Remaining Leave: $remainingLeave",
                        style: TextStyle(
                          fontSize: screenWidth / 28,
                          fontFamily: "NexaBold",
                          color: primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
