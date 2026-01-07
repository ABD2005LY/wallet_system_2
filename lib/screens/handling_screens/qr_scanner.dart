import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => QrScannerScreenState();
}

class QrScannerScreenState extends State<QrScannerScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Scan QR")),
      body: SizedBox.expand(
        child: MobileScanner(
          onDetect: (barcodeCapture) {
            final code = barcodeCapture.barcodes.first.rawValue;
            if (code != null) {
              Navigator.pop(context, code);
            }
          },
        ),
      ),
    );
  }
}
