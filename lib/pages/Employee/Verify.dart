import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hadeer_app/pages/loginpage.dart';
import 'package:pinput/pinput.dart';
import 'package:quickalert/quickalert.dart';

import 'Otp.dart';

class VerifyAccount extends StatefulWidget {
  const VerifyAccount({Key? key}) : super(key: key);

  @override
  State<VerifyAccount> createState() => _VerifyAccountState();
}

class _VerifyAccountState extends State<VerifyAccount> {
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(30, 60, 87, 1),
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromARGB(255, 148, 215, 147)),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  final FirebaseAuth auth = FirebaseAuth.instance;

  String codeOtp = "";

  @override
  Widget build(BuildContext context) {
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromARGB(255, 148, 215, 147)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('Images/verifyAcc.gif'),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Account Verification',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'We need to verify your account before getting started!',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                showCursor: true,
                onChanged: (value) {
                  setState(() {
                    codeOtp = value;
                  });
                },
                onSubmitted: (code) {
                  verifyOTP(code);
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      navigateToOtpVerification();
                    },
                    child: const Text(
                      'Edit Phone Number ?',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void verifyOTP(String code) async {
    try {
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
        verificationId: OtpVerification.verify,
        smsCode: code,
      ))
          .then((value) {
        if (value.user != null) {
          showSuccessAlert();
          navigateToLoginPage();
        }
      });
    } catch (e) {
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wrong OTP Code!')),
      );
    }
  }

  void showSuccessAlert() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'You have successfully registered!',
    );
  }

  void navigateToLoginPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  void navigateToOtpVerification() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OtpVerification()),
    );
  }
}
