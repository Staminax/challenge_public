import 'package:auto_size_text/auto_size_text.dart';
import 'package:bemagro_weather/globals/utility/utility.dart';
import 'package:bemagro_weather/providers/search_history_provider.dart';
import 'package:bemagro_weather/shared/cities/cities.dart';
import 'package:bemagro_weather/shared/search_history/search_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CityPicker extends ConsumerWidget {
  final List<City> cities;
  final bool hasConnection;

  const CityPicker({
    super.key,
    required this.cities,
    required this.hasConnection,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchHistory = ref.watch(searchHistoryProvider);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.adaptive.arrow_back_outlined, size: 30),
              ),
            ),
          ],
        ),
        if (hasConnection) ...[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Autocomplete<City>(
                optionsBuilder: (TextEditingValue value) {
                  if (value.text.isEmpty) {
                    return const Iterable<City>.empty();
                  }

                  String normalizedInput = sanitize(value.text.toLowerCase());

                  return cities.where((City option) {
                    final normalizedCityName =
                        sanitize(option.name.toLowerCase());
                    return normalizedCityName.startsWith(normalizedInput);
                  });
                },
                displayStringForOption: (City option) => option.name,
                onSelected: (City selectedCity) {
                  ref.read(searchHistoryProvider.notifier).addSearchHistory(
                        SearchHistory(
                          name: selectedCity.name,
                          uf: selectedCity.uf,
                          latitude: selectedCity.lat.toString(),
                          longitude: selectedCity.lon.toString(),
                        ),
                      );

                  Navigator.pop(context, selectedCity);
                },
                fieldViewBuilder: (context, textEditingController, focusNode,
                    onFieldSubmitted) {
                  return TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    onFieldSubmitted: (value) => onFieldSubmitted,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      border: OutlineInputBorder(gapPadding: 1),
                      hintText: "Search for a city...",
                    ),
                  );
                },
              ),
            ),
          ),
        ] else ...[
          const Padding(
            padding: EdgeInsets.all(20),
            child: AutoSizeText(
                'Você não possui conexão para realizar buscas, mas ainda pode verificar seu histórico :)'),
          ),
        ],
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AutoSizeText('Histórico de buscas'),
              Visibility(
                visible: searchHistory.isNotEmpty,
                child: TextButton(
                  onPressed: () {
                    ref.read(searchHistoryProvider.notifier).clearHistory();
                  },
                  child: const AutoSizeText('Limpar Histórico'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: searchHistory.isEmpty
              ? Center(
                  child: AutoSizeText('Você ainda não realizou buscas.'),
                )
              : ListView.builder(
                  itemCount: searchHistory.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: AutoSizeText(searchHistory[index].name),
                      trailing: IconButton(
                        onPressed: () {
                          ref
                              .read(searchHistoryProvider.notifier)
                              .deleteSearchHistory(searchHistory[index].id);
                        },
                        icon: const Icon(Icons.close),
                      ),
                      onTap: () {
                        Navigator.pop(
                            context,
                            City(
                              name: searchHistory[index].name,
                              uf: searchHistory[index].uf,
                              lat: double.tryParse(
                                      searchHistory[index].latitude) ??
                                  0.0,
                              lon: double.tryParse(
                                      searchHistory[index].longitude) ??
                                  0.0,
                            ));
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  static Future<City?> showCityPicker(
    BuildContext context, {
    required List<City> cities,
    required bool hasConnection,
  }) async {
    return await showModalBottomSheet<City>(
      isDismissible: false,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) {
        return CityPicker(
          cities: cities,
          hasConnection: hasConnection,
        );
      },
    );
  }
}
