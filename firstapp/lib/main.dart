import 'package:firstapp/gradient_container.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: GradientContainer(
            Color.fromARGB(255, 102, 45, 140), Color.fromARGB(255, 237, 7, 98)),
      ),
    ),
  );
}
