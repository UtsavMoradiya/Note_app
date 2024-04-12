import 'package:flutter/material.dart';
import 'package:googlenote/search_screen.dart';

import 'drawer_screen.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  IconData currentIcon = Icons.horizontal_split_outlined;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarwidget(),
      body: _centerwidget(),
      drawer: const DrawerScreen(),
    );
  }

  _appbarwidget() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: Builder(builder: (context) {
        return GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
        );
      }),
      title: const Text(
        "Archive",
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchScreen(),
              ),
            );
          },
          child: const Icon(
            Icons.search,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        IconButton(
          onPressed: () {
            setState(() {
              if (currentIcon == Icons.horizontal_split_outlined) {
                currentIcon = Icons.check_box_outline_blank;
              } else {
                currentIcon = Icons.horizontal_split_outlined;
              }
            });
          },
          icon: Icon(
            currentIcon,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _centerwidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.archive_outlined,
            color: Colors.orangeAccent,
            size: 130,
          ),
          Text("Your archived notes appear here"),
        ],
      ),
    );
  }
}
