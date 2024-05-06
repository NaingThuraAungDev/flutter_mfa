import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mfa_app/qr_popup.dart';
import 'package:otp/otp.dart';
import 'dart:developer' as out_log;

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController otpTextController = TextEditingController();
  String _validateResult = '';

  void _showQRCode() {
    showDialog(
        context: context,
        builder: (context) {
          // if you want to generate a new secret key
          // open the comment below
          // String sk = generateBase32Secret();

          // for testing purposes, we will use a fixed secret key ETCIU5S5DDW3DUSWNPMP
          const String finalString =
              "otpauth://totp/mfa%3Anaing?secret=ETCIU5S5DDW3DUSWNPMP&issuer=nta";
          return const QRPopup(qrData: finalString);
        });
  }

  String generateBase32Secret({int length = 20}) {
    final random = Random.secure();
    const charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    return List.generate(
        length, (index) => charset[random.nextInt(charset.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _validateResult,
              style: const TextStyle(color: Colors.greenAccent, fontSize: 20.0),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: otpTextController,
                decoration: const InputDecoration(
                    labelText: 'Enter Code', border: OutlineInputBorder()),
              ),
            ),
            ElevatedButton(
                onPressed: validateOTP, child: const Text('Validate'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showQRCode,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> validateOTP() async {
    try {
      final otpCode = OTP.generateTOTPCodeString(
          'ETCIU5S5DDW3DUSWNPMP', DateTime.now().millisecondsSinceEpoch,
          interval: 30, algorithm: Algorithm.SHA1, isGoogle: true);
      if (otpTextController.text == otpCode) {
        out_log.log("OTP verification successful");
        _validateResult = 'OTP verification successful';
      } else {
        out_log.log("OTP verification failed");
        _validateResult = 'OTP verification failed';
      }
      setState(() => _validateResult);
    } catch (e) {
      out_log.log("Error verifying OTP: $e");
    }
  }
}
