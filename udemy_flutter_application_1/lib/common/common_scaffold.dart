import 'package:flutter/material.dart';
import 'package:udemy_flutter_application_1/common/gradient_widget.dart';

class CommonScaffold extends StatelessWidget {
  const CommonScaffold({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    print("Build Common Scaffold Widget");
    return Scaffold(
      backgroundColor: Colors.red,
      body: GradientWidget(
        child: child,
      ),
    );
  }
}
