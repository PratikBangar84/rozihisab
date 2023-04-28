import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/qrScanner.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  List date = [DateTime.now().toString()];
  addDate() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'attendance': FieldValue.arrayUnion(date)}).then((value) {
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => homepage()),
      //     (Route<dynamic> route) => false);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Attendance marked!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            height: 300,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          addDate();
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //       builder: (context) => QrScanner()),
                          // );
                        },
                        child: Text('Mark Attendace')),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
