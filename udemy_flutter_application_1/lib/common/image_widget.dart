import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget(
    this.assetPath, {
    super.key,
  });

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    print("Build Image Widget");
    return Image.asset(
      assetPath,
      height: 150,
      width: 150,
    );
  }
}
