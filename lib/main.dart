import 'package:flutter/material.dart';
import 'package:flutter_liveness_verification/liveness_verification/liveness_verification_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Liveness Verification',
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: const Color.fromARGB(255, 7, 12, 146),
        ),
      ),
      home: const LivenessVerificationPage(),
    );
  }
}
