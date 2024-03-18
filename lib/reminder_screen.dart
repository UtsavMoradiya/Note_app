import 'package:flutter/material.dart';
import 'package:googlenote/search_screen.dart';

import 'drawer_screen.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  IconData currentIcon = Icons.horizontal_split_outlined;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarwidget(),
      body:  _centerwidget(),
        drawer: const DrawerScreen(),
        floatingActionButton: _buttonwidget(),
        bottomNavigationBar: _bottomappbarwidget());
  }
  Widget _bottomappbarwidget() {
    return BottomAppBar(
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              // Navigate or perform some action
            },
            icon: const Icon(Icons.done_outlined),
          ),
          IconButton(
            onPressed: () {
              // Navigate or perform some action
            },
            icon: const Icon(Icons.brush_outlined),
          ),
          IconButton(
            onPressed: () {
              // Navigate or perform some action
            },
            icon: const Icon(Icons.keyboard_voice_outlined),
          ),
          IconButton(
            onPressed: () {
              // Navigate or perform some action
            },
            icon: const Icon(Icons.photo_outlined),
          ),
        ],
      ),
    );
  }
 _appbarwidget(){
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
            ));
      }),
      title: const Text("Reminders",style: TextStyle(color: Colors.black),),
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
        const SizedBox(width: 10,),
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
Widget _centerwidget(){
    return Center(
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_sharp, color: Colors.orangeAccent,size: 130,),
          Text("Notes with upcoming reminders appear here"),
        ],
      ),
    );
}
  Widget _buttonwidget() {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
      // onPressed: () {},
      child: const Icon(
        Icons.add,
        size: 38,
      ),
    );
  }
}
