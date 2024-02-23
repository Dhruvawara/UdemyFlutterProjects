import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:udemy_flutter_application_1/quizFlow/models/quiz_question.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key, required this.quizQuestionList});

  final List<QuizQuestion> quizQuestionList;

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  int currentQuestionIndex = 0;
  bool isFinalPage = false;
  List<int> listOfAnswer = [];

  void onOptionClick(int index) {
    if (currentQuestionIndex < (widget.quizQuestionList.length - 1)) {
      setState(() {
        listOfAnswer.add(index);
        ++currentQuestionIndex;
      });
    } else {
      setState(() {
        listOfAnswer.add(index);
        isFinalPage = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isFinalPage) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.quizQuestionList[currentQuestionIndex].question,
            style: GoogleFonts.nabla(
              fontSize: 27,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(7),
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return OutlinedButton(
                style: const ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.lightGreenAccent),
                ),
                onPressed: () => onOptionClick(index),
                child: Text(
                  widget.quizQuestionList[currentQuestionIndex]
                      .questionList[index],
                  style: GoogleFonts.poorStory(
                    fontSize: 17,
                  ),
                ),
              );
            },
            itemCount: widget
                .quizQuestionList[currentQuestionIndex].questionList.length,
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
            label: const Text('Quit'),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "You answered X questions out of ${listOfAnswer.length} Questions currently",
            style: GoogleFonts.rubikGlitch(
              fontSize: 21,
            ),
            textAlign: TextAlign.center,
          ),
          for (int i = 0; i < widget.quizQuestionList.length; i++)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text('${i+1}'),
                ),
                const Gap(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.quizQuestionList[i].question),
                      const Gap(5),
                      Text(
                        widget.quizQuestionList[i].questionList.first,
                        textAlign: TextAlign.left,
                      ),
                      const Gap(5),
                      Text(widget.quizQuestionList[i].questionList.first),
                      const Gap(15),
                    ],
                  ),
                )
              ],
            ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_circle_left_outlined,
              color: Colors.white,
            ),
            label: const Text('Quit'),
          ),
        ],
      );
    }
  }
}
