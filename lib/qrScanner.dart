import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/homepage.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({Key? key}) : super(key: key);

  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;
  List date = [DateTime.now().toString()];
  var marked;
  bool isFirstTime = true;

  addDate() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'attendance': FieldValue.arrayUnion(date)}).then((value) {
      controller!.dispose();

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

  mark() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('marked', true);
  }

  isMarked() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    marked = prefs.getBool('marked');
    print(marked);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    isMarked();
    mark();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return marked == null
        ? Scaffold(
            body: Stack(
            alignment: Alignment.center,
            children: [
              buildQrView(context),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.15,
                child: buildResult(),
              )
            ],
          ))
        : marked == false
            ? Scaffold(
                body: Stack(
                alignment: Alignment.center,
                children: [
                  buildQrView(context),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.15,
                    child: buildResult(),
                  )
                ],
              ))
            : Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Text(
                    'You have already marked\nyour attendance for today.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              );
  }

  Widget buildResult() {
    return Container(
        decoration: BoxDecoration(color: Colors.white24),
        child: Text(
          'Scan QR code',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ));
  }

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
          borderRadius: 10,
        ),
      );

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((barcode) async {
      setState(() {
        this.barcode = barcode;
      });

      if (barcode.code == 'Welcome !!') {
        addDate();
      }
    });
  }
}
