import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const QrAdminPage());
}

class QrAdminPage extends StatelessWidget {
  const QrAdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async {
          // This will prevent the app from minimizing
          return false;
        },
        child: Scaffold(
          backgroundColor: const Color(0xFF1A1A1A),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'QR Scanner',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => _scanQrCode(context),
                  child: const Text('Scan QR Code'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _scanQrCode(BuildContext context) async {
    try {
      final result = await BarcodeScanner.scan();
      if (result.rawContent.isNotEmpty) {
        final qrData = result.rawContent.split("\n");
        if (qrData.length >= 4) {
          final name = qrData[0].split(":")[1].trim();
          final rollNumber = qrData[1].split(":")[1].trim();
          final sportChoice = qrData[2].split(":")[1].trim();
          final timestamp = DateTime.parse(qrData[3].split(":")[1].trim());
          await _addEntryToFirestore(context, rollNumber, name, sportChoice, timestamp);
          _showDialog(context, 'Success', 'Entry added successfully!');
        } else {
          _showDialog(context, 'Error', 'Invalid QR code format!');
        }
      } else {
        _showDialog(context, 'Error', 'No QR code scanned!');
      }
    } catch (e) {
      print('Error scanning QR code: $e');
      _showDialog(context, 'Error', 'Scanning failed!');
    }
  }

  Future<void> _addEntryToFirestore(BuildContext context, String rollNumber, String name, String sportChoice, DateTime timestamp) async {
    try {
      String formattedTimestamp = DateFormat('yyyy-MM-dd_HH:mm:ss').format(timestamp);
      await FirebaseFirestore.instance
          .collection('entries')
          .doc(rollNumber)
          .collection('scans')
          .doc(formattedTimestamp)
          .set({
        'name': name,
        'rollNumber': rollNumber,
        'sportChoice': sportChoice,
        'timestamp': timestamp,
      });
    } catch (e) {
      print('Error adding entry to Firestore: $e');
      _showDialog(context, 'Error', 'Failed to add entry to Firestore!');
    }
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
