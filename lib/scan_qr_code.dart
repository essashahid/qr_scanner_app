import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanQrCode extends StatefulWidget {
  const ScanQrCode({super.key});

  @override
  State<ScanQrCode> createState() => _ScanQrCodeState();
}

class _ScanQrCodeState extends State<ScanQrCode> {
  String qrResult = 'Scanned Data will appear here';

  Future<void> scanQr() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      if (!mounted) return;
      setState(() {
        qrResult = qrCode;
      });
    } on PlatformException {
      setState(() {
        qrResult = 'Failed to read QR Code';
      });
    }
  }

  void _launchURL() async {
    final uri = Uri.parse(qrResult);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('Could not launch $qrResult');
      throw 'Could not launch $qrResult';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Code Scanner')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Text(
              qrResult,
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: scanQr,
              child: Text('Scan Code'),
            ),
            if (qrResult != 'Scanned Data will appear here' &&
                qrResult != 'Failed to read QR Code')
              ElevatedButton(
                onPressed: _launchURL,
                child: Text('Open Link'),
              ),
          ],
        ),
      ),
    );
  }
}
