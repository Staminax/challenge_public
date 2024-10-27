import 'dart:convert';

import 'package:bemagro_weather/globals/dio_client/dio_client.dart';
import 'package:bemagro_weather/globals/endpoints/endpoints.dart';
import 'package:bemagro_weather/globals/keys_or_params/keys_or_params.dart';
import 'package:bemagro_weather/globals/utility/utility.dart';
import 'package:bemagro_weather/shared/last_search/last_search.dart';
import 'package:bemagro_weather/shared/last_search/last_search_controller.dart';
import 'package:bemagro_weather/shared/weather_data/daily/daily.dart';
import 'package:bemagro_weather/shared/weather_data/daily_weather/daily_weather.dart';
import 'package:bemagro_weather/shared/weather_data/temperature/temperature.dart';
import 'package:bemagro_weather/shared/weather_data/weather/weather.dart';
import 'package:bemagro_weather/shared/weather_data/weather_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final selectedLocationProvider =
    StateProvider<({double latitude, double longitude})>((ref) {
  return (
    latitude: 0.0,
    longitude: 0.0,
  );
});

final weatherProvider = AsyncNotifierProvider<WeatherNotifier, WeatherData>(() {
  return WeatherNotifier();
});

class WeatherNotifier extends AsyncNotifier<WeatherData> {
  @override
  Future<WeatherData> build() async {
    final location = ref.watch(selectedLocationProvider);

    final double latitude = location.latitude;
    final double longitude = location.longitude;

    return await fetchWeatherData(latitude, longitude);
  }

  Future<WeatherData> fetchAndCacheWeatherData(
    double latitude,
    double longitude,
    LastSearchController lastSearchController,
  ) async {
    try {
      final Response response = await DioClient.get(
        '${Endpoints.OPENWEATHER_FORECAST_URL}?lat=$latitude&lon=$longitude&exclude=minutely,hourly&lang=pt_br&units=metric&appid=${KeysOrParams.OPEN_WEATHER_API_KEY}',
      );

      List<Daily> dailys = [];

      if (response.statusCode == 200) {
        WeatherData wd = WeatherData.fromJson(response.data);

        String last8DayForecastDate = timestampToSimpleDate(
          wd.daily!.last.dt!,
          isInSeconds: true,
        );

        DateTime nextForecastDate = DateTime.parse(last8DayForecastDate);
        nextForecastDate = nextForecastDate.add(const Duration(days: 1));

        for (int i = 0; i < 3; i++) {
          nextForecastDate = nextForecastDate.add(const Duration(days: 1));

          String date = DateFormat('yyyy-MM-dd').format(nextForecastDate);

          final Response responseExtraDays = await DioClient.get(
              '${Endpoints.OPENWEATHER_NEXT_DAYS_URL}lat=$latitude&lon=$longitude&date=$date&units=metric&appid=${KeysOrParams.OPEN_WEATHER_API_KEY}');

          if (responseExtraDays.statusCode == 200) {
            DailyWeather dailyWeather =
                DailyWeather.fromJson(responseExtraDays.data);

            int ts = 0;
            ts = simpleDateToTimestamp(date) ~/ 1000;

            dailys.add(
              Daily(
                dt: ts,
                temp: Temperature(
                  min: dailyWeather.temperature?.min ?? 0,
                  max: dailyWeather.temperature?.max ?? 0,
                ),
                humidity: dailyWeather.humidity?.afternoon?.toInt() ?? 0,
                rain: dailyWeather.precipitation?.total ?? 0,
                weather: [Weather(description: 'SEM PREVISÃO')],
              ),
            );
          }
        }
      }

      LastSearch? lastSearch = await lastSearchController.first();
      WeatherData weatherData = WeatherData.fromJson(response.data);

      if (dailys.isNotEmpty) {
        weatherData.daily?.addAll(dailys);
      }

      if (lastSearch != null) {
        lastSearch.weatherDataJSON = jsonEncode(weatherData);
        await lastSearchController.update(lastSearch);
      }

      return weatherData;
    } catch (e) {
      throw Exception("Failed to fetch weather data");
    }
  }

  Future<WeatherData> fetchWeatherData(
      double latitude, double longitude) async {
    final lastSearchController = LastSearchController();

    if (await isOnline()) {
      return await fetchAndCacheWeatherData(
          latitude, longitude, lastSearchController);
    } else {
      return await loadCachedWeatherData(lastSearchController);
    }
  }

  Future<WeatherData> loadCachedWeatherData(
    LastSearchController lastSearchController,
  ) async {
    try {
      LastSearch? lastSearch = await lastSearchController.first();

      if (lastSearch != null && lastSearch.weatherDataJSON.isNotEmpty) {
        try {
          return WeatherData.fromJson(jsonDecode(lastSearch.weatherDataJSON));
        } catch (jsonError) {
          throw Exception(jsonError.toString());
        }
      }

      return WeatherData();
    } catch (e) {
      throw Exception(e.toString);
    }
  }
}
