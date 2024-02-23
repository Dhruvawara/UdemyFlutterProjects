// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:udemy_flutter_application_1/common/image_widget.dart';

// ignore: constant_identifier_names
const List<String> ASSET_IMAGES_LIST = [
  'assets/dice-1.png',
  'assets/dice-2.png',
  'assets/dice-3.png',
  'assets/dice-4.png',
  'assets/dice-5.png',
  'assets/dice-6.png',
];

final _randomize = Random();

class GetxRollDiceWidget extends GetView<RollDiceGetXController> {
  /// Path: `/get`
  static const routeName = '/get';

  const GetxRollDiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    print("Build Getx Roll Dice Widget");
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GetBuilder<RollDiceGetXController>(
            builder: (controller) {
              print("Build Getx inside Roll Dice Widget - Image");
              return ImageWidget(
                  ASSET_IMAGES_LIST[controller.selectedImageIndex]);
            },
          ),
          const Gap(7),
          ElevatedButton.icon(
            onPressed: controller.onDiceRollClick,
            icon: const Icon(Icons.refresh),
            label: const Text('Roll Dice'),
          ),
          const Gap(7),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_circle_left_outlined),
            label: const Text('Back'),
          ),
        ],
      ),
    );
  }
}

class RollDiceGetXController extends GetxController {
  int selectedImageIndex = 0;

  onDiceRollClick() {
    selectedImageIndex = _randomize.nextInt(6);
    update();
  }
}
