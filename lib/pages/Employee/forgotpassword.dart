import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ResetpasswodPage.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController userIdController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();

  Color primary = const Color.fromARGB(255, 148, 215, 147);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text('Forgot Password'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 24.0),
            TextField(
              controller: userIdController,
              decoration: const InputDecoration(
                labelText: 'User ID',
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: phoneNumController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                final String id = userIdController.text.trim();
                final String phoneNumber = phoneNumController.text.trim();

                if (id.isNotEmpty && phoneNumber.isNotEmpty) {
                  _sendOTP(id, phoneNumber);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Error'),
                      content: const Text(
                          'Please enter both User ID and Phone Number.'),
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
              child: const Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendOTP(String id, String phoneNumber) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      CollectionReference collection;
      if (id == 'admin') {
        collection = FirebaseFirestore.instance.collection('Admin');
      } else {
        collection = FirebaseFirestore.instance.collection('Employee');
      }
      QuerySnapshot snap = await collection.where('id', isEqualTo: id).get();
      // Send OTP to the provided phone number
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // This callback will be triggered automatically for iOS devices
          // when auto-verification of the OTP is done successfully.
          // You can also use this callback to handle scenarios such as
          // sign in with Apple ID or instant verification.
          await auth.signInWithCredential(credential);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordPage(userId: id),
            ),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Verification Failed'),
              content: Text('Failed to send OTP: ${e.message}'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordPage(
                userId: id,
                verificationId: verificationId,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to send OTP: $e'),
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
