import 'package:flutter/material.dart';

void main() {
  runApp(const ContactPage());
}

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 50, bottom: 20),
              alignment: Alignment.bottomLeft,
              child: const Text(
                'CONTACT US',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContactInfo(title: 'Email', info: 'arjuna@gmail.com'),
                  _buildContactInfo(title: 'Phone', info: '+919618516737'),
                  const SizedBox(height: 20),
                  const Text(
                    'IIITDM Kancheepuram Off Vandalur- Kelambakkam Road Chennai-600127',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'For any inquiries or assistance, feel free to contact us using the information above',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white),
                  const SizedBox(height: 300),
                  const Text(
                    '2023. Indian Institute Of Information and Manufacturing. Kancheepuram',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo({required String title, required String info}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          info,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
