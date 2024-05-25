import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const QrPage());
}

class QrPage extends StatefulWidget {
  const QrPage({Key? key}) : super(key: key);

  @override
  _QrGeneratorState createState() => _QrGeneratorState();
}

class _QrGeneratorState extends State<QrPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollNumberController = TextEditingController();
  String? _sportChoice;
  String _qrContent = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Entry In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _rollNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Roll Number',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your roll number';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Sport Choice',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    dropdownColor: const Color.fromRGBO(118, 171, 174, 1),
                    value: _sportChoice,
                    items: ['Gym', 'Badminton']
                        .map((sport) => DropdownMenuItem(
                              value: sport,
                              child: Text(
                                sport,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _sportChoice = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a sport';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _generateQrCode();
                          _showQrCodeDialog(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(118, 171, 174, 1),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _generateQrCode() async {
    try {
      String currentTime = DateTime.now().toString();
      final rollNumber = _rollNumberController.text;

      final rollNumberSnapshot = await FirebaseFirestore.instance
          .collection('registration')
          .doc(rollNumber)
          .get();

      if (rollNumberSnapshot.exists) {
        _qrContent = 'Name: ${_nameController.text}\n'
            'Roll Number: $rollNumber\n'
            'Sport Choice: $_sportChoice\n'
            'Time: $currentTime';
        _showQrCodeDialog(context);
      } else {
        _showDeniedDialog(context);
      }
    } catch (e) {
      print('Error generating QR code: $e');
    }
  }

  void _showDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Access Denied'),
          content: const Text('Roll number not found in database'),
          actions: <Widget>[
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


  void _showQrCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('QR Code'),
          content: SizedBox(
            width: 250,
            height: 250,
            child: Center(
              child: BarcodeWidget(
                barcode: Barcode.qrCode(),
                data: _qrContent,
                color: Colors.black,
                errorBuilder: (context, error) => Text('Error: $error'),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
