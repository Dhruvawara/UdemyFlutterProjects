import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:udemy_flutter_application_1/main_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MainApp()));
}
