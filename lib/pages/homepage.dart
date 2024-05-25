import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'contact.dart';
import 'equiplist.dart';
import 'fillin.dart';
import 'gallery.dart';
import 'login.dart';
import 'qr.dart';
import 'noti.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text(
          'Welcome to Arjuna',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FutureBuilder<List<String>>(
            future: _fetchNotifications(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final notifications = snapshot.data ?? [];
                return ShortNotiPage(notifications: notifications);
              }
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ScrollGroup(image: 'assets/images/equip.jpg', title: 'Equipment Update'),
                  SizedBox(height: 16),
                  ScrollGroup(image: 'assets/images/gal.png', title: 'Gallery'),
                  SizedBox(height: 16),
                  ScrollGroup(image: 'assets/images/contact.jpg', title: 'Contact Us'),
                ],
              ),
            ),
          ),
          const NavigationBar(),
        ],
      ),
    );
  }

  Future<List<String>> _fetchNotifications() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .limit(3)
          .get();
      final notifications = querySnapshot.docs.map((doc) => doc['message'] as String).toList();
      return notifications;
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }
}

class ShortNotiPage extends StatelessWidget {
  final List<String> notifications;
  const ShortNotiPage({Key? key, this.notifications = const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final notification in notifications.take(3))
                      _buildNotificationText(notification),
                  ],
                ),
              ),
              SizedBox(height: 15)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationText(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class ScrollGroup extends StatelessWidget {
  final String image;
  final String title;

  const ScrollGroup({Key? key, required this.image, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          if (title == 'Equipment Update') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EquiplistPage()), // Navigate to EquiplistPage
            );
          } else if (title == 'Gallery') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GalleryPage()), // Navigate to GalleryPage
            );
          } else if (title == 'Contact Us') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ContactPage()), // Navigate to ContactPage
            );
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            width: 350,
            height: 270,
            color: const Color(0xFF1A1A1A),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    color: Colors.transparent,
                    onPressed: () {
                      if (title == 'Equipment Update') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EquiplistPage()),
                        );
                      } else if (title == 'Gallery') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const GalleryPage()),
                        );
                      } else if (title == 'Contact Us') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ContactPage()),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NavigationBar extends StatefulWidget {
  const NavigationBar({Key? key}) : super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: const Color.fromRGBO(118, 171, 174, 1),
      ),
      child: SizedBox(
        height: 85,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            switch (index) {
              case 0:
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FillinPage()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QrPage()),
                );
                break;
              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationPage()),
                );
                break;
              case 4:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
                break;
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/home.png', width: 24, height: 24),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/form.png', width: 24, height: 24),
              label: 'Fillin',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 50,
                height: 40,
                child: Image.asset('assets/images/qr.png', width: 24 + 5, height: 24 + 5),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/sched.png', width: 24, height: 24),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/admin.png', width: 24, height: 24),
              label: 'Admin',
            ),
          ],
        ),
      ),
    );
  }
}
