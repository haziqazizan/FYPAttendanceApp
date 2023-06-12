import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hadeer_app/pages/Employee/MenuPage.dart';
import 'package:hadeer_app/pages/Employer/menuEmp.dart';
import 'package:hadeer_app/pages/model/employee.dart';
import 'package:hadeer_app/pages/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Hadeer App',
      debugShowCheckedModeBanner: false,
      home: AuthCheck(),
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool userAvailable = false;
  String? userRole;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  // Fetches the current user from SharedPreferences
  Future<void> _getCurrentUser() async {
    SharedPreferences spref = await SharedPreferences.getInstance();

    try {
      final String? userId = spref.getString('userId');

      setState(() {
        if (userId != null) {
          Employee.userID = userId;
          userAvailable = true;
        } else {
          userAvailable = false;
        }
      });
    } catch (e) {
      setState(() {
        userAvailable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getCurrentUser(),
      builder: (context, snapshot) {
        if (userAvailable) {
          if (Employee.userID == "admin") {
            return const MenuEmp();
          } else {
            return const MenuPage();
          }
        } else {
          return const Splash();
        }
      },
    );
  }
}
