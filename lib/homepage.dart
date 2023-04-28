import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/salary.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  var items = [
    'assets/images/ctc.png',
    'assets/images/gi.jpg',
    'assets/images/pf.jpg',
    'assets/images/tax.jpg'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text('Salary'),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          children: [
            SizedBox(
              height: 35,
            ),
            Container(
              child: Image.asset('assets/images/Logo.jpg'),
            ),
            SizedBox(
              height: 20,
            ),
            GridView.count(
              physics: ScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              shrinkWrap: true,
              children: List.generate(
                4,
                (index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (_) => product(index)));
                        },
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(items[index]),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  var data = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .get();
                  var attendance = data['attendance'];
                  var salary = 10000 * attendance.length +
                      50 * attendance.length +
                      5500 * attendance.length;
                  print(salary);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => Salary(
                              salary: salary,
                            )),
                  );
                },
                child: Text('Submit'))
          ],
        )),
      ),
    );
  }
}
