import 'package:flutter/material.dart';

class CreateLabelScreen extends StatefulWidget {
  const CreateLabelScreen({super.key});

  @override
  State<CreateLabelScreen> createState() => _CreateLabelScreenState();
}

class _CreateLabelScreenState extends State<CreateLabelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarwidget(),

      body: _buildtextfild()
    );
  }
  Widget _buildtextfild(){
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        hintText: "Create new label",
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: GestureDetector(
          onTap: () {
          },
          child: const Icon(Icons.cancel_outlined,color: Colors.black,),
        ),
        suffixIcon: const Icon(Icons.done,color: Colors.black,),
        fillColor: Colors.grey.shade100,
        filled: true,
        focusedBorder: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(),
      ),
    );
  }
  _appbarwidget(){
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      title: const Text(
        "Edit labels",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
