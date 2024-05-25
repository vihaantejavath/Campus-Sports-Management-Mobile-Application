import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const UpdatePage());
}

class UpdatePage extends StatelessWidget {
  const UpdatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 50),
            Text(
              'Equipment Update',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            EquipmentUpdateForm(),
          ],
        ),
      ),
    );
  }
}

class EquipmentUpdateForm extends StatefulWidget {
  const EquipmentUpdateForm({Key? key}) : super(key: key);

  @override
  _EquipmentUpdateFormState createState() => _EquipmentUpdateFormState();
}

class _EquipmentUpdateFormState extends State<EquipmentUpdateForm> {
  final TextEditingController equipmentNameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: equipmentNameController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Equipment Name',
            labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 30),
        TextFormField(
          controller: quantityController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Quantity',
            labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 50),
        ElevatedButton(
          onPressed: () {
            if (_isMounted) {
              _updateEquipmentQuantity(context);
            }
          },
          child: const Text('Update Quantity'),
        ),
      ],
    );
  }

  Future<void> _updateEquipmentQuantity(BuildContext context) async {
    try {
      final String equipmentName = equipmentNameController.text.trim();
      final int newQuantity = int.parse(quantityController.text.trim());

      final DocumentReference equipmentRef =
      FirebaseFirestore.instance.collection('equipment').doc(equipmentName);

      final DocumentSnapshot equipmentSnapshot = await equipmentRef.get();
      if (equipmentSnapshot.exists) {

        await equipmentRef.update({'quantity': newQuantity});
      } else {

        await equipmentRef.set({'quantity': newQuantity});
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Equipment quantity updated successfully')),
      );

      equipmentNameController.clear();
      quantityController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update equipment quantity')),
      );
    }
  }
}
