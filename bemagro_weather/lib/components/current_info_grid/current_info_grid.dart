import 'package:auto_size_text/auto_size_text.dart';
import 'package:bemagro_weather/shared/weather_data/current/current.dart';
import 'package:flutter/material.dart';

class CardData {
  final String title;
  final String value;

  CardData({
    required this.title,
    required this.value,
  });
}

class CurrentInfoGrid extends StatelessWidget {
  final Current currentWeatherData;

  const CurrentInfoGrid({super.key, required this.currentWeatherData});

  @override
  Widget build(BuildContext context) {
    int hour = DateTime.now().hour;
    bool uvIndexOrPressure = hour < 18 && hour >= 6;

    final double scaleValue = MediaQuery.of(context).textScaler.scale(1.3);
    final double aspectRatio = 1.0 + ((scaleValue - 1.0) * 0.5);

    final List<CardData> cardData = [
      CardData(
        title: 'SENSAÇÃO TÉRMICA',
        value: '${currentWeatherData.feelsLike?.toStringAsFixed(0)}°C',
      ),
      CardData(
          title: uvIndexOrPressure ? 'ÍNDICE U.V' : 'PRESSÃO',
          value: uvIndexOrPressure
              ? currentWeatherData.uvi!.toString()
              : '${currentWeatherData.pressure} HPA'),
      CardData(
          title: 'VELOCIDADE DO VENTO',
          value: '${currentWeatherData.windSpeed} KM/H'),
      CardData(title: 'UMIDADE', value: '${currentWeatherData.humidity}%'),
    ];

    return IgnorePointer(
      ignoring: true,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: aspectRatio,
        ),
        itemCount: cardData.length,
        padding: const EdgeInsets.all(5),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(cardData[index].title),
                  AutoSizeText(
                    cardData[index].value,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
