import 'package:bemagro_weather/globals/dio_client/dio_client.dart';
import 'package:bemagro_weather/globals/endpoints/endpoints.dart';
import 'package:bemagro_weather/globals/keys_or_params/keys_or_params.dart';
import 'package:bemagro_weather/globals/utility/utility.dart';
import 'package:bemagro_weather/shared/closest_city/closest_city.dart';
import 'package:bemagro_weather/shared/closest_city/closest_city_controller.dart';
import 'package:bemagro_weather/shared/last_search/last_search.dart';
import 'package:bemagro_weather/shared/last_search/last_search_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final closestCityProvider =
    AsyncNotifierProvider<ClosestCityNotifier, ClosestCityState>(() {
  return ClosestCityNotifier();
});

final locationProvider = FutureProvider<Position>((ref) async {
  return await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.best,
    ),
  );
});

class ClosestCityNotifier extends AsyncNotifier<ClosestCityState> {
  @override
  Future<ClosestCityState> build() async {
    try {
      final position = await ref.read(locationProvider.future);
      return await fetchAndSaveCity(
        position.latitude,
        position.longitude,
        ClosestCityController(),
        LastSearchController(),
      );
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      return ClosestCityState(errorMessage: error.toString());
    }
  }

  Future<ClosestCityState> fetchAndSaveCity(
    double latitude,
    double longitude,
    ClosestCityController closestCityController,
    LastSearchController lastSearchController,
  ) async {
    if (await isOnline()) {
      try {
        final Response response = await DioClient.get(
          '${Endpoints.GEONAMES_API_URL}?lat=$latitude&lng=$longitude&username=${KeysOrParams.GEONAMES_API_USERNAME}',
        );

        if (response.statusCode == 200) {
          final cityData = response.data['geonames'].first;
          final closestCity = closestCityController.fromMap(cityData);

          await lastSearchController.deleteAll();
          await lastSearchController.insert(
            LastSearch(
              name: closestCity.name,
              lat: closestCity.lat,
              lng: closestCity.lng,
            ),
          );

          return ClosestCityState(closestCity: closestCity);
        } else {
          throw Exception("Failed to fetch city data: ${response.statusCode}");
        }
      } catch (e) {
        return ClosestCityState(errorMessage: e.toString());
      }
    } else {
      LastSearch? lastSearch = await lastSearchController.first();
      if (lastSearch != null) {
        return ClosestCityState(lastSearch: lastSearch);
      } else {
        return const ClosestCityState(
            errorMessage:
                "No internet connection and no cached data available.");
      }
    }
  }

  Future<void> fetchClosestCity(double latitude, double longitude) async {
    final ClosestCityController closestCityController = ClosestCityController();
    final LastSearchController lastSearchController = LastSearchController();

    if (await isOnline()) {
      try {
        final response = await DioClient.get(
          '${Endpoints.GEONAMES_API_URL}?lat=$latitude&lng=$longitude&username=${KeysOrParams.GEONAMES_API_USERNAME}',
        );

        if (response.statusCode == 200) {
          final cityData = response.data['geonames'].first;
          final closestCity = closestCityController.fromMap(cityData);

          await lastSearchController.deleteAll();
          await lastSearchController.insert(
            LastSearch(
              name: closestCity.name,
              lat: closestCity.lat,
              lng: closestCity.lng,
            ),
          );

          state = AsyncData(ClosestCityState(closestCity: closestCity));
        } else {
          state = AsyncError(
            Exception("Failed to fetch city data: ${response.statusCode}"),
            StackTrace.current,
          );
        }
      } catch (e) {
        state = AsyncError(e, StackTrace.current);
      }
    } else {
      try {
        LastSearch? lastSearch = await lastSearchController.first();

        if (lastSearch != null) {
          state = AsyncData(
            ClosestCityState(
              lastSearch: lastSearch,
              closestCity: null,
            ),
          );
        } else {
          state = const AsyncData(
            ClosestCityState(errorMessage: 'No cached search data available.'),
          );
        }
      } catch (e) {
        state = AsyncError(e, StackTrace.current);
      }
    }
  }

  Future<ClosestCityState> loadLastSearch(
      LastSearchController lastSearchController) async {
    try {
      final LastSearch? lastSearch = await lastSearchController.first();
      return ClosestCityState(lastSearch: lastSearch);
    } catch (e) {
      return ClosestCityState(errorMessage: e.toString());
    }
  }
}

class ClosestCityState {
  final ClosestCity? closestCity;
  final LastSearch? lastSearch;
  final String? errorMessage;

  const ClosestCityState({
    this.closestCity,
    this.lastSearch,
    this.errorMessage,
  });
}
