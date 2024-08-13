// ignore_for_file: avoid_print, unused_local_variable, use_build_context_synchronously

import 'dart:developer';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signin_signout_tutorial/screens/authuntication/forgot_password.dart';
import 'package:signin_signout_tutorial/widgets/custombuttonauth.dart';
import 'package:signin_signout_tutorial/widgets/customtextfieldauth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 50),
              // const CustomLogoAuth(),
              Container(height: 20),
              const Text("Login",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              Container(height: 10),
              const Text("Login To Continue Using The App",
                  style: TextStyle(color: Colors.grey)),
              Container(height: 20),
              const Text(
                "Email",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Container(height: 10),
              CustomTextForm(
                  hinttext: "ُEnter Your Email", mycontroller: emailController),
              Container(height: 10),
              const Text(
                "Password",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Container(height: 10),
              CustomTextForm(
                  hinttext: "ُEnter Your Password",
                  mycontroller: passwordController),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ForgotPasswordScreen(),
                  ));
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 20),
                  alignment: Alignment.topRight,
                  child: const Text(
                    "Forgot Password ?",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          CustomButtonAuth(
              title: "login",
              onPressed: () async {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text);
                  bool isVerified =
                      FirebaseAuth.instance.currentUser!.emailVerified;
                  if (isVerified) {
                    Navigator.of(context).pushReplacementNamed("home_screen");
                  } else {
                    Navigator.of(context).pushReplacementNamed("verify_email");
                  }
                } on FirebaseAuthException catch (e) {
                  log(e.code);
                  CherryToast.warning(
                    description: const Text(
                      'Please confirm your informations, and check your connection.',
                      style: TextStyle(color: Colors.black),
                    ),
                    animationType: AnimationType.fromLeft,
                    actionHandler: () {},
                  ).show(context);
                }
              }),
          Container(height: 20),
          MaterialButton(
              height: 40,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.red[700],
              textColor: Colors.white,
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Login With Google  "),
                ],
              )),
          Container(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't Have An Account ?"),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed("signup");
                },
                child: Container(
                  color: Colors.transparent,
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Center(
                      child: Text(
                        "Register Here",
                        style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
