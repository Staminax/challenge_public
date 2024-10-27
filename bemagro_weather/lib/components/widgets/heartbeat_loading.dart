import 'package:auto_size_text/auto_size_text.dart';
import 'package:bemagro_weather/components/animations/heartbeat_animation.dart';
import 'package:flutter/material.dart';

class HeartbeatLoadingWidget extends StatelessWidget {
  final bool showAppName;
  const HeartbeatLoadingWidget({super.key, required this.showAppName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: showAppName,
              child: const AutoSizeText(
                'HEARTBEAT',
                style: TextStyle(
                  fontFamily: 'Nothing',
                  fontSize: 50,
                ),
              ),
            ),
            const SizedBox(
              width: 200,
              height: 100,
              child: HeartBeatAnimation(),
            ),
          ],
        ),
      ),
    );
  }
}
