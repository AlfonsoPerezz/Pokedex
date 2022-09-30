import 'package:flutter/material.dart';

class infoP extends StatelessWidget {
  const infoP({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text("Stateless page"),
      ),
      body: Center(child: Text("Quien es ese pokémon")),
    );
  }
}