import 'package:auto_size_text/auto_size_text.dart';
import 'package:bemagro_weather/components/animations/heartbeat_animation.dart';
import 'package:bemagro_weather/globals/utility/utility.dart';
import 'package:bemagro_weather/modules/entrypoint/entrypoint_page.dart';
import 'package:flutter/material.dart';

class NoConnectionScreen extends StatefulWidget {
  const NoConnectionScreen({super.key});

  @override
  State<NoConnectionScreen> createState() => _NoConnectionScreenState();
}

class _NoConnectionScreenState extends State<NoConnectionScreen> {
  Widget body() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: HeartBeatAnimation(),
              ),
            ),
            const AutoSizeText(
              'HEARTBEAT',
              style: TextStyle(
                fontFamily: 'Nothing',
                fontSize: 30,
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                const AutoSizeText(
                  'Não foi possível estabelecer uma conexão com a internet. Por favor, verifique.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () async {
                    bool hasConnection = false;
                    hasConnection = await isOnline();

                    if (hasConnection && mounted) {
                      Navigator.pushReplacement<void, void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const EntrypointPage(),
                        ),
                      );
                    }
                  },
                  child: const AutoSizeText(
                    'Tentar novamente',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
            ),
          ],
        ),
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
