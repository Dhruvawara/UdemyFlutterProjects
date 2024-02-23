import 'dart:math';

import 'package:flutter/material.dart';
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

class StateFulRollDiceWidget extends StatefulWidget {
  const StateFulRollDiceWidget({
    super.key,
  });

  /// Path: `/stateful`
  static const routeName = '/stateful';

  @override
  State<StateFulRollDiceWidget> createState() => _StateFulRollDiceWidgetState();
}

class _StateFulRollDiceWidgetState extends State<StateFulRollDiceWidget> {
  int selectedImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    print("Build Roll Dice Widget");
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageWidget(ASSET_IMAGES_LIST[selectedImageIndex]),
          const SizedBox(
            height: 7,
          ),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                selectedImageIndex = _randomize.nextInt(6);
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Roll Dice'),
          ),
          const SizedBox(
            height: 7,
          ),
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
