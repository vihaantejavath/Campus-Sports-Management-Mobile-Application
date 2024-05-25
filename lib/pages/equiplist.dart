import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const EquiplistPage());
}

class EquiplistPage extends StatelessWidget {
  const EquiplistPage({Key? key}) : super(key: key);

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
              'Inventory',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            width: 400,
            child: EquipmentDataTable(),
          ),
          const SizedBox(height: 0),
          const Divider(color: Colors.white),
        ],
      ),
    );
  }
}

class EquipmentDataTable extends StatelessWidget {
  const EquipmentDataTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('equipment').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error fetching data'),
          );
        }
        final data = snapshot.data!;
        return DataTable(
          columns: const [
            DataColumn(
              label: Text(
                'Equipment',
                style: TextStyle(color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'Quantity',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
          rows: data.docs.map((doc) {
            final equipment = doc.id;
            final quantity = doc['quantity'];
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    equipment,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                DataCell(
                  Text(
                    quantity.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
