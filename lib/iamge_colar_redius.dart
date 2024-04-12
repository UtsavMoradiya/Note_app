import 'package:flutter/material.dart';

class Shader extends StatefulWidget {
  const Shader({super.key});

  @override
  State<Shader> createState() => _ShaderState();
}

class _ShaderState extends State<Shader> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          ShaderMask(
            shaderCallback: (Rect bounds) {
              // Create a linear gradient shader for the mask
              return const LinearGradient(
                colors: [Colors.yellow, Colors.red],
                stops: [0.5, 0.9],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(bounds);
            },
            child: Image.asset("assets/images/ufo-1265186_1280.jpg",
              // width: 300.0,
              // height: 300.0,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(height: 50,),
          ShaderMask(
            shaderCallback: (Rect bounds) {
              // Create a linear gradient shader for the mask
              return LinearGradient(
                colors: [Colors.greenAccent, Colors.blue],
                stops: [0.5, 0.9],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(bounds);
            },
            child: Image.asset(
              'assets/images/ufo-1265186_1280.jpg',
              width: 300.0,
              height: 300.0,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
