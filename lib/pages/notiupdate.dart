import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const NotiUpdatePage());
}

class NotiUpdatePage extends StatelessWidget {
  const NotiUpdatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 50),
            Text(
              'Admin - Notification Update',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            NotificationInput(),
            const SizedBox(height: 20),
            Expanded(
              child: NotificationHistory(),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationInput extends StatefulWidget {
  const NotificationInput({Key? key}) : super(key: key);

  @override
  _NotificationInputState createState() => _NotificationInputState();
}

class _NotificationInputState extends State<NotificationInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            style: const TextStyle(color: Colors.white),
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Give ur notis here',
              hintStyle: const TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white),
              ),
              filled: true,
              fillColor: Colors.black,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.send, color: Colors.white),
          onPressed: () {
            _sendNotification(_controller.text);
            _controller.clear();
          },
        ),
      ],
    );
  }

  void _sendNotification(String message) {
    FirebaseFirestore.instance.collection('notifications').add({
      'message': message,
      'timestamp': DateTime.now(),
    });
  }
}

class NotificationHistory extends StatelessWidget {
  const NotificationHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('notifications').orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final data = snapshot.data!.docs;
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final notification = data[index];
            return ListTile(
              title: Text(
                notification['message'],
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                '${notification['timestamp'].toDate()}',
                style: const TextStyle(color: Colors.grey),
              ),
            );
          },
        );
      },
    );
  }
}
