import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:udemy_flutter_application_1/common/common_scaffold.dart';
import 'package:udemy_flutter_application_1/eventChannel/event_channel_widget.dart';
import 'package:udemy_flutter_application_1/expense_tracker/widgets/expenses.dart';
import 'package:udemy_flutter_application_1/getExample/getx_roll_dice_widget.dart';
import 'package:udemy_flutter_application_1/helloWorldExample/hello_world_widget.dart';
import 'package:udemy_flutter_application_1/methodChannel/method_channel_widget.dart';
import 'package:udemy_flutter_application_1/platformView/hybrid_composition_widget.dart';
import 'package:udemy_flutter_application_1/platformView/hybrid_composition_with_recycle_view_widget.dart';
import 'package:udemy_flutter_application_1/platformView/virtual_display_widget.dart';
import 'package:udemy_flutter_application_1/quizFlow/quiz_main_widget.dart';
import 'package:udemy_flutter_application_1/statefulExample/stateful_roll_dice_widget.dart';

// ignore: constant_identifier_names
const String HELLO_WORLD_STRING = 'hello world';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    print("Build Main App");
    return MaterialApp(
      initialRoute: HelloWorldWidget.routeName,
      routes: {
        StateFulRollDiceWidget.routeName: (context) => const CommonScaffold(
              child: StateFulRollDiceWidget(),
            ),
        HelloWorldWidget.routeName: (context) => const CommonScaffold(
              child: HelloWorldWidget(HELLO_WORLD_STRING),
            ),
        GetxRollDiceWidget.routeName: (context) {
          Get.put<RollDiceGetXController>(RollDiceGetXController());
          return const CommonScaffold(
            child: GetxRollDiceWidget(),
          );
        },
        MethodChannelWidget.routeName: (context) =>
            const CommonScaffold(child: MethodChannelWidget()),
        EventChannelWidget.routeName: (context) =>
            const CommonScaffold(child: EventChannelWidget()),
        HybridCompositionWidget.routeName: (context) =>
            const CommonScaffold(child: HybridCompositionWidget()),
        VirtualDisplayWidget.routeName: (context) =>
            const CommonScaffold(child: VirtualDisplayWidget()),
        HybridCompositionWithRecycleViewWidget.routeName: (context) =>
            const CommonScaffold(
                child: HybridCompositionWithRecycleViewWidget()),
        QuizMainWidget.routeName: (context) =>
            const CommonScaffold(child: QuizMainWidget()),
        Expenses.routeName: (context) =>
            const CommonScaffold(child: Expenses()),
      },
      // getPages: [
      //   GetPage(
      //       name: GetxRollDiceWidget.routeName,
      //       page: () => const CommonScaffold(
      //             child: GetxRollDiceWidget(),
      //           ),
      //       binding: BindingsBuilder(() {}),),
      // ],
    );
  }
}
