import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartScreen extends StatelessWidget {
  const StartScreen(this.startQuiz, {super.key});
  final void Function() startQuiz;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/quiz-logo.png',
            width: 300,
            color: const Color.fromARGB(150, 255, 255, 255),
          ),
          const SizedBox(
            height: 50,
          ),
          Text(
            style: GoogleFonts.dmSans(
                color: const Color.fromARGB(255, 47, 128, 237),
                fontSize: 28,
                fontWeight: FontWeight.bold),
            'Learn Flutter the Fun way!',
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton.icon(
            onPressed: startQuiz,
            label: Text(
              'Start Quiz',
              style: GoogleFonts.dmSans(
                color: const Color.fromARGB(255, 47, 128, 237),
                fontSize: 15,
              ),
            ),
            icon: const Icon(
              Icons.play_arrow_outlined,
              color: Color.fromARGB(255, 47, 128, 237),
            ),
          )
        ],
      ),
    );
  }
}
