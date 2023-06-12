import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import '../model/employee.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class EmpAttendance extends StatefulWidget {
  final String lv, sp, fn;
  const EmpAttendance({
    Key? key,
    required this.lv,
    required this.sp,
    required this.fn,
  }) : super(key: key);

  @override
  State<EmpAttendance> createState() => _EmpAttendanceState();
}

class _EmpAttendanceState extends State<EmpAttendance> {
  //display a pdf document
  Future<void> _displayPDF() async {
    String sp = widget.sp;
    String fn = widget.fn;
    final doc = pw.Document();

    // Retrieve the attendance records
    final snapshot = await FirebaseFirestore.instance
        .collection("Employee")
        .doc(sp)
        .collection("Record")
        .get();

    // Add the title and date
    doc.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                " $fn Attendance History",
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                "Date: ${DateFormat('MMMM d, yyyy').format(DateTime.now())}",
                style: pw.TextStyle(fontSize: 16),
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                context: context,
                data: <List<String>>[
                  <String>['Date', 'Check In', 'Check Out'],
                  for (final attendanceDoc in snapshot.docs)
                    <String>[
                      DateFormat('MMMM d, yyyy')
                          .format(attendanceDoc['date'].toDate()),
                      attendanceDoc['checkIn'],
                      attendanceDoc['checkOut'],
                    ],
                ],
              ),
            ],
          );
        },
      ),
    );

    // Open the preview screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(doc: doc),
      ),
    );
  }

  String entry = "09:00:00";
  String leave = "16:30:00";

  String ci = "--/--";
  String co = "--/--";

  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color.fromARGB(255, 79, 120, 78);

  String _month = DateFormat('MMMM').format(DateTime.now());

  List<QueryDocumentSnapshot<Map<String, dynamic>>> snap = [];

  @override
  Widget build(BuildContext context) {
    String sp = widget.sp;
    String fn = widget.fn;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SingleChildScrollView(
      padding: const EdgeInsets.all(29),
      child: Column(
        children: [
          Stack(children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 32),
              child: Text(
                "${fn} Attendance",
                style: TextStyle(
                  fontFamily: "NexaBold",
                  fontSize: screenWidth / 18,
                ),
              ),
            ),
          ]),
          Stack(
            children: [
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(left: 250, top: 35),
                child: Center(
                  child: ElevatedButton(
                    onPressed: _displayPDF,
                    child: const Icon(Icons.download_rounded),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 32),
                child: GestureDetector(
                  onTap: () async {
                    final month = await showMonthYearPicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2099),
                        builder: (context, child) {
                          return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                    primary: primary,
                                    secondary: primary,
                                    onSecondary: Colors.white),
                                textButtonTheme: TextButtonThemeData(
                                    style:
                                        TextButton.styleFrom(primary: primary)),
                                textTheme: const TextTheme(
                                  headline4: TextStyle(
                                    fontFamily: "NexaBold",
                                  ),
                                  overline: TextStyle(
                                    fontFamily: "NexaBold",
                                  ),
                                  button: TextStyle(
                                    fontFamily: "NexaBold",
                                  ),
                                ),
                              ),
                              child: child!);
                        });

                    if (month != null) {
                      setState(() {
                        _month = DateFormat('MMMM').format(month);
                      });
                    }
                  },
                  child: Text(
                    _month,
                    style: TextStyle(
                      fontFamily: "NexaBold",
                      fontSize: screenWidth / 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: screenHeight / 1.5,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Employee")
                  .doc(sp)
                  .collection("Record")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  final snap = snapshot.data!.docs;

                  return ListView.builder(
                      itemCount: snap.length,
                      itemBuilder: (context, index) {
                        //initialize string
                        String de = (snap[index]['checkIn']);
                        String dl = (snap[index]['checkOut']);

                        //compare between two string
                        var le = de.compareTo(entry);
                        var el = dl.compareTo(leave);

                        //if else statement to get the string value from firestore.
                        if (dl == "--/--") {
                          //parse string to date time
                          DateTime time1 = DateFormat("HH:mm")
                              .parse((snap[index]['checkIn']));

                          ci = DateFormat("hh:mm").format(time1);
                          co = "--/--";
                        } else {
                          //parse string to date time
                          DateTime time1 = DateFormat("HH:mm")
                              .parse((snap[index]['checkIn']));
                          DateTime time2 = DateFormat("HH:mm")
                              .parse((snap[index]['checkOut']));
                          //convert 24h to 12h format
                          ci = DateFormat("hh:mm").format(time1);
                          co = DateFormat("hh:mm").format(time2);
                        }

                        //this method is for a freelance working time but need to complete 8 hours a day

                        // DateTime getTime(final String inputString) =>
                        //     DateFormat("hh:mm").parse(inputString);

                        // String getString(final Duration duration) {
                        //   String formatDigits(int n) =>
                        //       n.toString().padLeft(2, '0');
                        //   final String minutes =
                        //       formatDigits(duration.inMinutes.remainder(60));
                        //   return "${formatDigits(duration.inHours)}:$minutes";
                        // }

                        // final String difference = getString(getTime(time2).difference(getTime(time1)));

                        return DateFormat('MMMM')
                                    .format(snap[index]['date'].toDate()) ==
                                _month
                            ? Container(
                                margin: EdgeInsets.only(
                                    top: index > 0 ? 12 : 0, left: 6, right: 3),
                                height: 150,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: Container(
                                      margin: const EdgeInsets.only(),
                                      decoration: BoxDecoration(
                                          color: primary,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Center(
                                        child: Text(
                                          DateFormat('EE\ndd').format(
                                              snap[index]['date'].toDate()),
                                          style: TextStyle(
                                              fontFamily: "NexaBold",
                                              fontSize: screenWidth / 18,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Check In",
                                            style: TextStyle(
                                                fontFamily: "NexaRegular",
                                                fontSize: screenWidth / 20,
                                                color: Colors.black54),
                                          ),
                                          (le < 0) //entry early than 9 AM
                                              ? Text(
                                                  ci,
                                                  style: TextStyle(
                                                      color: Colors.green[300],
                                                      fontFamily: "NexaBold",
                                                      fontSize:
                                                          screenWidth / 18),
                                                )
                                              : Text(
                                                  ci,
                                                  style: TextStyle(
                                                      color: Colors.red[900],
                                                      fontFamily: "NexaBold",
                                                      fontSize:
                                                          screenWidth / 18),
                                                )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Check Out",
                                            style: TextStyle(
                                                fontFamily: "NexaRegular",
                                                fontSize: screenWidth / 20,
                                                color: Colors.black54),
                                          ),
                                          (el < 0) //leave early than 4:30 PM
                                              ? Text(
                                                  co,
                                                  style: TextStyle(
                                                      color: Colors.red[900],
                                                      fontFamily: "NexaBold",
                                                      fontSize:
                                                          screenWidth / 18),
                                                )
                                              : //else
                                              Text(
                                                  co,
                                                  style: TextStyle(
                                                      color: Colors.green[300],
                                                      fontFamily: "NexaBold",
                                                      fontSize:
                                                          screenWidth / 18),
                                                )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox();
                      });
                } else {
                  return Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(16.0),
                    child: Card(
                      color: Color.fromARGB(255, 180, 107, 107),
                      elevation: 2.0,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'No data found',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    ));
  }
}

class PreviewScreen extends StatelessWidget {
  final pw.Document doc;

  const PreviewScreen({
    Key? key,
    required this.doc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        centerTitle: true,
        title: const Text("Preview"),
      ),
      body: PdfPreview(
        build: (format) => doc.save(),
        allowSharing: true,
        allowPrinting: true,
        initialPageFormat: PdfPageFormat.a4,
        pdfFileName: "mydoc.pdf",
      ),
    );
  }
}
