import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRPopup extends StatelessWidget {
  final String qrData;

  const QRPopup({super.key, required this.qrData});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Scan QR Code'),
      content: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 200.0,
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Scan this QR code with Google Authenticator',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the popup
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
