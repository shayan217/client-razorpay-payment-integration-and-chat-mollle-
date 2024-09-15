import 'package:flutter/material.dart';
import 'package:molle/Utils/constants.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../Settings/settings.dart';

class QRCodeScreen extends StatelessWidget {
  const QRCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.mainColor,
        title: const Text(
          'Share Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: "sidray12",
              size: 200.0,
              backgroundColor: Colors.white, // White background for QR code
            ),
            const SizedBox(height: 16.0),
            const Text(
              'sidray12',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      elevation: 3, backgroundColor: ColorConstants.mainColor2),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.share,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Share',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      elevation: 3, backgroundColor: ColorConstants.mainColor2),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.qr_code,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Share QR',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Share your QR-Code, so other users can follow you',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
