import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tubes_iot/screen/component/header.dart';
import 'package:tubes_iot/style/color.dart';
import 'package:tubes_iot/style/text.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  TextEditingController? controllerInput = TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
          child: Column(
            children: <Widget>[
              const Header(),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Scan Kode Qr",
                style: text_18_700,
              ),
              Text(
                "Pastikan qr terbaca dengan jelas",
                style: text_12_300,
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(flex: 2, child: _buildQrView(context, controller)),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                  
                    Text(
                      'Atau Masukan kode',
                      style: text_18_700,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: smoothGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: controllerInput,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 10),
                            hintText: "masukan kode disini",
                            hintStyle:
                                TextStyle(color: Colors.black.withOpacity(0.2)),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(15.0),
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              lightOrange,
                              orange,
                            ]),
                      ),
                      child: Center(
                        child: Text(
                          "Connect Now !",
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Widget _buildQrView(BuildContext context, QRViewController? controller) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 180.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return Stack(
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea),
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          width: MediaQuery.of(context).size.width,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            InkWell(
              onTap: () async {
                await controller?.toggleFlash();
                setState(() {});
              },
              child: CircleAvatar(
                radius: 17,
                backgroundColor: Colors.white.withOpacity(0.3),
                child: const FaIcon(
                  FontAwesomeIcons.bolt,
                  color: Colors.white,
                  size: 17,
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await controller?.flipCamera();
                setState(() {});
              },
              child: CircleAvatar(
                radius: 17,
                backgroundColor: Colors.white.withOpacity(0.3),
                child: const FaIcon(
                  FontAwesomeIcons.rotate,
                  color: Colors.white,
                  size: 17,
                ),
              ),
            ),
          ]),
        )
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        controllerInput?.text = result!.code.toString();
        // controllerInput?.text = "hmmm";
        // print("test");
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
