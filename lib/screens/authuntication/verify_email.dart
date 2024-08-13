import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  int sendLinkTimerStart = 20;
  Timer? sendLinkTimer;
  bool timerisRunning = true;

  void startTimerToSendLink() {
    const oneSec = Duration(seconds: 1);
    sendLinkTimer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (sendLinkTimerStart == 0) {
          timerisRunning = false;

          setState(() {});
        } else if (sendLinkTimerStart != 0 && timerisRunning == true) {
          setState(() {
            sendLinkTimerStart--;
          });
        }
      },
    );
  }

  void _sendEmailVerification() async {
    await FirebaseAuth.instance.currentUser!.sendEmailVerification();
  }

  //!   THIS TIMER VERIFY IF THE EMAIL VERIFIED OR NOT (DURATION: 5 SEC)_______________________________________
  int _start = 3;
  Timer? _timer;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          // ? fonction to verify Email.
          _checkEmailVerification();
          //? Restart the timer
          _start = 3;
        } else {
          setState(() {
            //? CountDown
            _start--;
          });
        }
      },
    );
  }

  void _checkEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    if (user != null && user.emailVerified) {
      Navigator.of(context).pushReplacementNamed("home_screen");
      print('Email is verified');
      // Add your logic here after email verification
    } else {
      print('Email is not verified');
      // Handle unverified email case here
    }
  }

//! ____________________________________________________________________________________________________________
  @override
  void initState() {
    super.initState();
    _sendEmailVerification();
    startTimer();
    startTimerToSendLink();
  }

  @override
  void dispose() {
    _timer?.cancel();
    sendLinkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
          children: [
            const SizedBox(height: 100),
            const Text("Verify Email",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Verify Your Email To Continue Using The App",
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                _sendEmailVerification();
                sendLinkTimerStart = 20;
                timerisRunning = true;
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(50)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 40),
                  child: Text(
                    "Click Here",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
                textAlign: TextAlign.center,
                "We will send you a link to your email.\nClick on it to complete the registration steps.",
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Timer: $sendLinkTimerStart',
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
