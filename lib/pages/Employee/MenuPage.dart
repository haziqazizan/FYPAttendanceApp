import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hadeer_app/pages/Employer/EmployerHome.dart';
import 'package:hadeer_app/pages/services/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../model/employee.dart';
import 'History.dart';
import 'attendance.dart';
import 'homeScreen.dart';
import 'leave.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color.fromARGB(255, 148, 215, 147);
  late SharedPreferences sharedPreferences;
  bool userAvailable = false;

  int currentIndex = 1;

  List<IconData> navigatonIcons = [
    FontAwesomeIcons.history,
    FontAwesomeIcons.signInAlt,
    FontAwesomeIcons.running
  ];

  @override
  void initState() {
    super.initState();
    _startLocation();
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

//check balik bhg sini ttg refresh
  Future refresh() async {
    setState(() {
      AuthCheck;
    });
  }

  void _startLocation() async {
    locationService().initialize();

    locationService().getLogitude().then((value) {
      setState(() {
        Employee.long = value!;
      });

      locationService().getLatitude().then((value) {
        setState(() {
          Employee.lat = value!;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            padding: EdgeInsets.only(
                right: screenWidth / 20, bottom: screenHeight / 10),
            onPressed: () async {
              SharedPreferences spref = await SharedPreferences.getInstance();
              if (spref.getString('userId') != null) {
                await spref.clear().then((value) => Navigator.of(context)
                    .pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                        (route) => false));
              }
            },
            icon: const Icon(
              Icons.logout_rounded,
              color: Color.fromARGB(255, 249, 120, 120),
              size: 40,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: IndexedStack(
          index: currentIndex,
          children: [History(), Attendance(), Leave()],
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(40),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(2, 2),
              )
            ]),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < navigatonIcons.length; i++) ...<Expanded>{
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = i;
                    });
                  },
                  child: Container(
                    height: screenHeight,
                    width: screenWidth,
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            navigatonIcons[i],
                            color: i == currentIndex ? primary : Colors.black54,
                            size: i == currentIndex ? 32 : 24,
                          ),
                          i == currentIndex
                              ? Container(
                                  margin: const EdgeInsets.only(top: 6),
                                  height: 3,
                                  width: 24,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(40)),
                                      color: primary),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ))
              }
            ],
          ),
        ),
      ),
    );
  }
}
