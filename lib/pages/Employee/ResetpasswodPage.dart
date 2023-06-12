import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../loginpage.dart';

class ResetPasswordPage extends StatefulWidget {
  final String userId;
  final String verificationId;

  const ResetPasswordPage(
      {super.key, required this.userId, this.verificationId = ''});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController otpController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  Color primary = const Color.fromARGB(255, 148, 215, 147);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text('Reset Password'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 24.0),
            TextField(
              controller: otpController,
              decoration: const InputDecoration(
                labelText: 'OTP',
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(
                labelText: 'New Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                final String otp = otpController.text.trim();
                final String newPassword = newPasswordController.text.trim();

                if (otp.isNotEmpty && newPassword.isNotEmpty) {
                  _updatePassword(widget.userId, otp, newPassword);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Error'),
                      content:
                          const Text('Please enter both OTP and New Password.'),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text('Update Password'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updatePassword(
      String userId, String otp, String newPassword) async {
    try {
      if (userId.isNotEmpty) {
        QuerySnapshot snap = await FirebaseFirestore.instance
            .collection("Employee")
            .where('id', isEqualTo: userId)
            .get();

        await FirebaseFirestore.instance
            .collection("Employee")
            .doc(snap.docs[0].id)
            .update({'password': newPassword});
        // Optional: Sign out the user after updating the password
        // await FirebaseAuth.instance.signOut();

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Password updated successfully.'),
            actions: [
              TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) => LoginPage())));
                  }),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to update password. User not found.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to update password: $e'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }
}
