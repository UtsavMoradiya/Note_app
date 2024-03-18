import 'package:flutter/material.dart';
// import 'package:googlenote/fire_base_screen.dart';

import 'drawer_screen.dart';

class DeletScreen extends StatefulWidget {
  const DeletScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<DeletScreen> createState() => _DeletScreenState();
}

class _DeletScreenState extends State<DeletScreen> {
  // final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarWidget(),
      body: _centerWidget(),
      drawer: const DrawerScreen(),
    );
  }

  AppBar _appBarWidget() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
          );
        },
      ),
      title: const Text(
        "Deleted",
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _centerWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.delete,
            color: Colors.orangeAccent,
            size: 130,
          ),
          Text("No notes in Recycle Bin"),
        ],
      ),
    );
  }
}
