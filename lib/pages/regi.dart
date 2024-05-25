import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const StudentsPage());
}

class StudentsPage extends StatelessWidget {
  const StudentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            alignment: Alignment.bottomLeft,
            child: const Text(
              'Registered Students',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('registration').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final documents = snapshot.data!.docs;

                  return DataTable(
                    columns: const [
                      DataColumn(label: Text('Name', style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text('Roll Number', style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text('Email', style: TextStyle(color: Colors.white))),
                    ],
                    rows: documents.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(data['name'] ?? '', style: const TextStyle(color: Colors.white)),
                          ),
                          DataCell(
                            Text(data['rollNumber'] ?? '', style: const TextStyle(color: Colors.white)),
                          ),
                          DataCell(
                            Text(data['email'] ?? '', style: const TextStyle(color: Colors.white)),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
