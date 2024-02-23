import 'package:flutter/material.dart';
import 'package:udemy_flutter_application_1/staticData/questions.dart';
import 'package:udemy_flutter_application_1/quizFlow/questions_screen.dart';
import 'package:udemy_flutter_application_1/quizFlow/quiz.dart';

class QuizMainWidget extends StatefulWidget {
  const QuizMainWidget({super.key});

  /// Path: `/quizMain`
  static const String routeName = "/quizMain";

  @override
  State<QuizMainWidget> createState() => _QuizMainWidgetState();
}

class _QuizMainWidgetState extends State<QuizMainWidget> {
  bool isStartScreen = true;

  void onOpenQuestionsScreenClick() {
    setState(() {
      isStartScreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: isStartScreen
            ? Quiz(
                onStartClick: onOpenQuestionsScreenClick,
              )
            : QuestionsScreen(quizQuestionList: questions));
  }
}
