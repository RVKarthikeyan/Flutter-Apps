import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AnswerButton extends StatelessWidget {
  const AnswerButton(this.txt, this.onTap, {super.key});
  final String txt;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 47, 128, 237),
          foregroundColor: const Color.fromARGB(255, 86, 204, 242),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40)),
      child: Text(
        txt,
        textAlign: TextAlign.center,
      ),
    );
  }
}
