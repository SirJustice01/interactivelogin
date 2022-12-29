import 'package:flutter/material.dart';
import 'package:interactive_login/screens/screens.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interactive Login',
      initialRoute: InteractiveLoginScreen.route,
      routes: {
        InteractiveLoginScreen.route: (_) => const InteractiveLoginScreen(),
      },
    );
  }
}
