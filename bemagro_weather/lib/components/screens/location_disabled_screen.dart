import 'package:auto_size_text/auto_size_text.dart';
import 'package:bemagro_weather/components/animations/heartbeat_animation.dart';
import 'package:bemagro_weather/modules/entrypoint/entrypoint_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationDisabledScreen extends StatefulWidget {
  const LocationDisabledScreen({super.key});

  @override
  State<LocationDisabledScreen> createState() => _LocationDisabledScreenState();
}

class _LocationDisabledScreenState extends State<LocationDisabledScreen>
    with WidgetsBindingObserver {
  Widget body() {
    return Center(
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
              fontSize: 50,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const AutoSizeText(
                  'Por favor, habilite o serviço de Localização para usar o aplicativo.',
                  textAlign: TextAlign.center,
                ),
              ],
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      verifyLocationEnabled();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> verifyLocationEnabled() async {
    bool serviceEnabled = false;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (serviceEnabled && mounted) {
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const EntrypointPage(),
        ),
      );
    }
  }
}
