import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:udemy_flutter_application_1/eventChannel/event_channel_widget.dart';
import 'package:udemy_flutter_application_1/expense_tracker/widgets/expenses.dart';
import 'package:udemy_flutter_application_1/getExample/getx_roll_dice_widget.dart';
import 'package:udemy_flutter_application_1/methodChannel/method_channel_widget.dart';
import 'package:udemy_flutter_application_1/platformView/hybrid_composition_widget.dart';
import 'package:udemy_flutter_application_1/platformView/hybrid_composition_with_recycle_view_widget.dart';
import 'package:udemy_flutter_application_1/platformView/virtual_display_widget.dart';
import 'package:udemy_flutter_application_1/quizFlow/quiz_main_widget.dart';
import 'package:udemy_flutter_application_1/statefulExample/stateful_roll_dice_widget.dart';

class HelloWorldWidget extends StatefulWidget {
  const HelloWorldWidget(
    this.text, {
    super.key,
  });

  /// Path: `/helloWorld`
  static const routeName = '/helloWorld';

  final String text;

  @override
  State<HelloWorldWidget> createState() => _HelloWorldWidgetState();
}

class _HelloWorldWidgetState extends State<HelloWorldWidget> {
  @override
  Widget build(BuildContext context) {
    print("Build Hello World Widget");
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Gap(7),
        Text(widget.text),
        const Gap(7),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, StateFulRollDiceWidget.routeName);
          },
          icon: const Icon(Icons.arrow_circle_right_outlined),
          label: const Text('Stateful Roll Dice'),
        ),
        const Gap(7),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, GetxRollDiceWidget.routeName);
          },
          icon: const Icon(Icons.arrow_circle_right_outlined),
          label: const Text('Getx Stateful Roll Dice'),
        ),
        const Gap(7),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, MethodChannelWidget.routeName);
          },
          icon: const Icon(Icons.arrow_circle_right_outlined),
          label: const Text('Method Channel'),
        ),
        const Gap(7),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, EventChannelWidget.routeName);
          },
          icon: const Icon(Icons.arrow_circle_right_outlined),
          label: const Text('Event Channel'),
        ),
        const Gap(7),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, HybridCompositionWidget.routeName);
          },
          icon: const Icon(Icons.arrow_circle_right_outlined),
          label: const Text('Hybrid Composition PlateForm View'),
        ),
        const Gap(7),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, VirtualDisplayWidget.routeName);
          },
          icon: const Icon(Icons.arrow_circle_right_outlined),
          label: const Text('Virtual Display PlateForm View'),
        ),
        const Gap(7),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(
                context, HybridCompositionWithRecycleViewWidget.routeName);
          },
          icon: const Icon(Icons.arrow_circle_right_outlined),
          label: const Text('Hybrid Composition With Recycle View Widget'),
        ),
        const Gap(7),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, QuizMainWidget.routeName);
          },
          icon: const Icon(Icons.arrow_circle_right_outlined),
          label: const Text('Quiz App'),
        ),
        const Gap(7),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, Expenses.routeName);
          },
          icon: const Icon(Icons.arrow_circle_right_outlined),
          label: const Text('Expense App'),
        ),
      ],
    ));
  }
}
