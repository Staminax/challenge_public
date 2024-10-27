import 'package:bemagro_weather/components/screens/location_disabled_screen.dart';
import 'package:bemagro_weather/components/screens/no_connection_screen.dart';
import 'package:bemagro_weather/components/screens/permission_denied_screen.dart';
import 'package:bemagro_weather/globals/utility/utility.dart';
import 'package:bemagro_weather/modules/home/home.dart';
import 'package:bemagro_weather/shared/last_search/last_search.dart';
import 'package:bemagro_weather/shared/last_search/last_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class EntrypointPage extends StatefulWidget {
  const EntrypointPage({super.key});

  @override
  State<EntrypointPage> createState() => _EntrypointPageState();
}

class _EntrypointPageState extends State<EntrypointPage> {
  final LastSearchController lastSearchController = LastSearchController();

  List<LastSearch> lastSearched = <LastSearch>[];

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }

  Future<void> getLastOnlineSearch() async {
    lastSearched = [];
    lastSearched = await lastSearchController.getAll();
  }

  Future<void> handleNavigation() async {
    bool serviceEnabled = false;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      navigateToLocationDisabled();
      return;
    }

    PermissionStatus status = await Permission.location.request();

    bool hasConnection = await isOnline();

    await getLastOnlineSearch();

    if (!mounted) return;

    if (hasConnection) {
      if (status.isGranted) {
        navigateToHome();
      } else {
        navigateToPermissionDenied();
      }
    } else {
      if (status.isGranted) {
        if (lastSearched.isNotEmpty) {
          navigateToHome();
        } else {
          navigateToNoConnection();
        }
      } else {
        navigateToPermissionDenied();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    handleNavigation();
  }

  void navigateToHome() {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const HomePage(),
      ),
    );
  }

  void navigateToLocationDisabled() {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const LocationDisabledScreen(),
      ),
    );
  }

  void navigateToNoConnection() {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const NoConnectionScreen(),
      ),
    );
  }

  void navigateToPermissionDenied() {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const PermissionDeniedScreen(),
      ),
    );
  }
}
