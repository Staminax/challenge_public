import 'package:auto_size_text/auto_size_text.dart';
import 'package:bemagro_weather/components/animations/heartbeat_animation.dart';
import 'package:bemagro_weather/components/screens/no_connection_screen.dart';
import 'package:bemagro_weather/globals/utility/utility.dart';
import 'package:bemagro_weather/modules/home/home.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionDeniedScreen extends StatefulWidget {
  const PermissionDeniedScreen({super.key});

  @override
  State<PermissionDeniedScreen> createState() => _PermissionDeniedScreenState();
}

class _PermissionDeniedScreenState extends State<PermissionDeniedScreen>
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
                  'É necessário habilitar as permissões de Localização para utilizar o aplicativo.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () async {
                    await openAppSettings();
                  },
                  child: const AutoSizeText(
                    'Abrir Permissões',
                    style: TextStyle(
                      color: Colors.redAccent,
                    ),
                  ),
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
      verifyPermissions();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> handleNavigation({required bool isGranted}) async {
    bool hasConnection = await isOnline();

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!mounted) return;

    if (isGranted && serviceEnabled) {
      if (hasConnection) {
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const HomePage(),
          ),
        );
      } else {
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const NoConnectionScreen(),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> verifyPermissions() async {
    await handleNavigation(isGranted: await Permission.location.isGranted);
  }
}
