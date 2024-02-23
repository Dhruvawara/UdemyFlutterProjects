import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Quiz extends StatelessWidget {
  const Quiz({super.key, required this.onStartClick});

  final VoidCallback onStartClick;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/quiz-logo.png",
          width: 300,
          height: 500,
        ),
        const Gap(7),
        const Text("Learn Flutter the fun way!",
            style: TextStyle(color: Colors.white)),
        const Gap(7),
        OutlinedButton.icon(
          label:
              const Text("Start Quiz", style: TextStyle(color: Colors.white)),
          onPressed: onStartClick,
          icon: const Icon(
            Icons.arrow_right_alt_outlined,
            color: Colors.white,
          ),
        ),
        const Gap(7),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_circle_left_outlined,
            color: Colors.white,
          ),
          label: const Text('Back'),
        ),
      ],
    );
  }
}
