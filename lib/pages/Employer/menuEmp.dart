import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hadeer_app/pages/Employer/empDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Employee/homeScreen.dart';
import '../model/employee.dart';

class MenuEmp extends StatefulWidget {
  const MenuEmp({Key? key}) : super(key: key);

  @override
  State<MenuEmp> createState() => _MenuEmpState();
}

class _MenuEmpState extends State<MenuEmp> {
  final TextEditingController _searchController = TextEditingController();

  Color primary = const Color.fromARGB(255, 148, 215, 147);
  late SharedPreferences sharedPreferences;
  bool userAvailable = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onsearchChanged);
    getId();
  }

  _onsearchChanged() {
    if (kDebugMode) {
      print(_searchController.text);
    }
  }

  void getId() async {
    QuerySnapshot sp = await FirebaseFirestore.instance
        .collection("Admin")
        .where('id', isEqualTo: Employee.userID)
        .get();

    setState(() {
      Employee.user = sp.docs[0].id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
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
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Welcome Admin',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Employee')
                  .orderBy('FullName')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final snap = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: snap.length,
                    itemBuilder: (context, index) {
                      final au = snap[index];
                      return ListTile(
                        title: Text(au['FullName']),
                        subtitle: Text(au['Phone Num']),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => empDetails(
                                ep: au.id,
                                ide: au['id'],
                                sub: 'Leave',
                                sub1: 'Record',
                                fn: au['FullName'],
                                pn: au['Phone Num'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
