import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bemagro_weather/components/city_picker/city_picker.dart';
import 'package:bemagro_weather/components/current_info_grid/current_info_grid.dart';
import 'package:bemagro_weather/components/forecast_carousel/forecast_carousel.dart';
import 'package:bemagro_weather/components/screens/alerts_screen.dart';
import 'package:bemagro_weather/components/screens/error_screen.dart';
import 'package:bemagro_weather/components/widgets/heartbeat_loading.dart';
import 'package:bemagro_weather/globals/keys_or_params/keys_or_params.dart';
import 'package:bemagro_weather/globals/utility/utility.dart';
import 'package:bemagro_weather/modules/map/map_screen.dart';
import 'package:bemagro_weather/providers/closest_city_provider.dart';
import 'package:bemagro_weather/providers/weather_data_provider.dart';
import 'package:bemagro_weather/shared/cities/cities.dart';
import 'package:bemagro_weather/shared/weather_data/current/current.dart';
import 'package:bemagro_weather/shared/weather_data/daily/daily.dart';
import 'package:bemagro_weather/shared/weather_data/weather_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage>
    with WidgetsBindingObserver {
  List<City> cities = <City>[];

  bool hasConnection = false;

  Widget btSearchCity(BuildContext context) {
    return IconButton(
      onPressed: () async {
        if (!context.mounted) return;

        final City? pickedCity = await CityPicker.showCityPicker(
          context,
          cities: cities,
          hasConnection: hasConnection,
        );

        if (pickedCity != null) {
          await updateLocation(
            latitude: pickedCity.lat,
            longitude: pickedCity.lon,
          );
        }
      },
      icon: const Icon(
        Icons.search,
        size: 30,
      ),
    );
  }

  IconButton btShowAlerts(BuildContext context, WeatherData? weatherData) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlertScreen(
              alerts: weatherData?.alerts ?? [],
            ),
          ),
        );
      },
      icon: Icon(
        Icons.notification_important_outlined,
        color: weatherData?.alerts == null ? Colors.white : Colors.redAccent,
        size: 30,
      ),
    );
  }

  IconButton btShowMap(BuildContext context, ClosestCityState? closestCity) {
    return IconButton(
      onPressed: () async {
        if (!hasConnection) {
          final SnackBar snackBar = SnackBar(
            content: Text(
              'É necessário ter conexão com a internet para visualizar o Mapa.',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            behavior: SnackBarBehavior.floating,
            elevation: 10,
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            backgroundColor: Colors.red.shade300,
          );

          if (context.mounted) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }

          return;
        }

        if (closestCity != null && context.mounted) {
          await openMap(context, closestCity);
        }
      },
      icon: const Icon(
        Icons.south_america_sharp,
        size: 30,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final closestCityAsync = ref.watch(closestCityProvider);
    final weatherDataAsync = ref.watch(weatherProvider);

    return closestCityAsync.when(
      data: (closestCity) => weatherDataAsync.when(
        data: (weatherData) => buildScaffold(
          context,
          closestCity,
          closestCityAsync,
          weatherData,
        ),
        loading: () => const HeartbeatLoadingWidget(
          showAppName: true,
        ),
        error: (error, _) => ErrorScreen(
          errorMessage: error.toString(),
        ),
      ),
      loading: () => const HeartbeatLoadingWidget(
        showAppName: true,
      ),
      error: (error, _) => ErrorScreen(
        errorMessage: error.toString(),
      ),
    );
  }

  Scaffold buildScaffold(
    BuildContext context,
    ClosestCityState? closestCity,
    AsyncValue<ClosestCityState> closestCityAsync,
    WeatherData? weatherData,
  ) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 100,
        leading: btShowMap(context, closestCity),
        actions: [btSearchCity(context)],
        title: btShowAlerts(context, weatherData),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              AutoSizeText(
                namedDate(
                  weatherData?.current?.dt ?? nowToTimestamp(),
                ),
              ),
              AutoSizeText(
                closestCity?.closestCity?.name ??
                    closestCity?.lastSearch?.name ??
                    '',
                textAlign: TextAlign.center,
                maxLines: 1,
                softWrap: false,
                style: TextStyle(
                  fontSize: 50,
                ),
              ),
              AutoSizeText(
                getCloudCoverageDescription(
                  weatherData?.current?.clouds ?? 0,
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              AutoSizeText(
                '${weatherData?.current?.temp?.toStringAsFixed(0) ?? 'N/A'}°C',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 60),
              ),
              CurrentInfoGrid(
                currentWeatherData:
                    weatherData?.current ?? Current.placeholder(),
              ),
              const SizedBox(height: 5),
              ForecastCarousel(daily: weatherData?.daily ?? <Daily>[]),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkConnection({required bool isInit}) async {
    hasConnection = false;
    hasConnection = await isOnline();

    if (!isInit) {
      if (hasConnection) {
        Future.microtask(() => ref.refresh(weatherProvider));
        Future.microtask(() => ref.refresh(closestCityProvider));
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkConnection(
        isInit: false,
      );
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
    checkConnection(isInit: true);
    loadCitiesLocalData();
  }

  Future<void> loadCitiesLocalData() async {
    cities = [];

    final String json = await rootBundle
        .loadString('.${KeysOrParams.ASSETS_DATA_PATH}cities.json');

    final List jsonList = jsonDecode(json) as List;

    cities = jsonList.map((cityJson) => City.fromJson(cityJson)).toList();
  }

  Future<void> openMap(
      BuildContext context, ClosestCityState closestCity) async {
    if (!hasConnection) {
      if (!context.mounted) return;

      showConnectionSnackBar(context);
      return;
    }
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MapScreen(
            lat: double.parse(
                closestCity.closestCity?.lat ?? closestCity.lastSearch!.lat),
            long: double.parse(
                closestCity.closestCity?.lng ?? closestCity.lastSearch!.lng),
          ),
        ),
      );
    }
  }

  void showConnectionSnackBar(BuildContext context) {
    final SnackBar snackBar = SnackBar(
      content: const Text(
        'É necessário ter conexão com a internet para visualizar o Mapa.',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red.shade300,
      behavior: SnackBarBehavior.floating,
      elevation: 10,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> updateLocation(
      {required double latitude, required double longitude}) async {
    ref.read(selectedLocationProvider.notifier).state = (
      latitude: latitude,
      longitude: longitude,
    );

    await ref
        .read(closestCityProvider.notifier)
        .fetchClosestCity(latitude, longitude);
  }
}
