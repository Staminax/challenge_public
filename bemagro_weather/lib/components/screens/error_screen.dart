import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String errorMessage;
  const ErrorScreen({super.key, required this.errorMessage});

  Widget body() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const AutoSizeText(
            'HEARTBEAT',
            style: TextStyle(
              fontFamily: 'Nothing',
              fontSize: 50,
            ),
          ),
          const AutoSizeText(
            textAlign: TextAlign.center,
            'An Unhandled error has occured.',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          AutoSizeText(
            textAlign: TextAlign.center,
            'Details: $errorMessage',
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }
}
