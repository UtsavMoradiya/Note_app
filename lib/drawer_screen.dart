

import 'package:flutter/material.dart';
import 'package:googlenote/home_screen.dart';
import 'package:googlenote/reminder_screen.dart';

import 'archive_screen.dart';
import 'create_label_screen.dart';
import 'delet_screen.dart';

class DrawerScreen extends StatelessWidget {

  const DrawerScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                RichText(
                  text: const TextSpan(
                    text: 'G',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: 'o',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: 'o',
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: 'g',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: 'l',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: 'e',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  "Keep",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
            ListTile(
              leading: const Icon(Icons.lightbulb_outline, color: Colors.black),
              title: const Text('Notes', style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_none_sharp, color: Colors.black),
              title: const Text('Reminders', style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReminderScreen(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.add, color: Colors.black),
              title: const Text('Create new label', style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateLabelScreen(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive_outlined, color: Colors.black),
              title: const Text('Archive', style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ArchiveScreen(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.black),
              title: const Text('Deleted', style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DeletScreen(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.black),
              title: const Text('Settings', style: TextStyle(color: Colors.black)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.black),
              title: const Text('Help & feedback', style: TextStyle(color: Colors.black)),
              onTap: () {},
            ),
            // Add more ListTiles or customize as needed
          ],
        ),
      ),
    );
  }
}
