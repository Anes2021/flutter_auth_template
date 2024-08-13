import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signin_signout_tutorial/widgets/customtextfieldauth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final String fullName = "1";
  TextEditingController dataName = TextEditingController();

  List<QueryDocumentSnapshot> data = [];

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where('Id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get(); //Here we will get data from FB
    data.addAll(querySnapshot.docs); // put our data in our storage
  }

  deleteData(int i) async {
    await getData();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(data[i + 1].id)
        .delete(); //Here we will get data from FB
    data = [];
    await getData(); //We just add this to refresh the ui
  }

  @override
  initState() {
    super.initState();
    getData();
    setState(() {});
  }

  Future<void> addData() async {
    try {
      await users.add({
        'full_name': dataName.text, //Anes Hellalet
        'Id': FirebaseAuth.instance.currentUser!.uid,
      });
      data = [];
      await getData();
    } catch (e) {
      print("Failed to add user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Text(
            'Test Firestore Operations',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.grey[300],
          shadowColor: Colors.black,
          elevation: sqrt1_2,
          actions: [
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.withOpacity(0.3),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.logout,
                    size: 25,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            )
          ],
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    Expanded(
                      // Wrap GridView.builder in Expanded
                      child: GridView.builder(
                        itemCount: data
                            .length, // Total number of items = number of our data
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of columns
                          crossAxisSpacing: 10.0, // Spacing between columns
                          mainAxisSpacing: 10.0, // Spacing between rows
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              deleteData(index);
                              setState(() {});
                            },
                            child: Container(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              child: Center(
                                child: Text(
                                  '${data[index]['full_name']}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Show the modal bottom sheet when the user taps the container
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 200,
                              color: Colors.grey[200],
                              child: Center(
                                child: Column(
                                  children: [
                                    const Text('Add Data'),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomTextForm(
                                        hinttext: 'DataName',
                                        mycontroller: dataName),
                                    ElevatedButton(
                                      child: const Text('Add'),
                                      onPressed: () async {
                                        await addData();
                                        setState(() {});
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.grey.withOpacity(0.8),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.add, size: 40),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
