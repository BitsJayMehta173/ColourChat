import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:path_provider/path_provider.dart';

import 'globals.dart';

class QRViewExample extends StatefulWidget {
  @override
  _QRViewExampleState createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;  // Initialize as nullable, Nullable variable to hold the scan result
  QRViewController? controller;  // Initialize as nullable, Nullable variable to manage QRView's state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Code Scanner')),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text('Data: ${result!.code}')
                  : Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _storeQRText() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    // /data/user/0/com.example.chatapp/app_flutter/qrText.txt
    final file = File('$path/$currfriend.txt');
    await file.writeAsString(receiverLang);
    print('$path/qrText.txt');
    print('done');
  }

  void _onQRViewCreated(QRViewController controller){
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
        receiverLang=scanData.code!;
        print(scanData.code);
        });
        await _storeQRText();
    });
  }

  @override
  void dispose() {
    controller?.dispose(); // Ensures proper disposal to prevent memory leaks,release resources used by the QR code scanning
    super.dispose();
  }
}
