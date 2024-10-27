import 'package:auto_size_text/auto_size_text.dart';
import 'package:bemagro_weather/globals/keys_or_params/keys_or_params.dart';
import 'package:bemagro_weather/globals/utility/utility.dart';
import 'package:bemagro_weather/shared/weather_data/daily/daily.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ForecastCarousel extends StatelessWidget {
  final List<Daily> daily;

  const ForecastCarousel({super.key, required this.daily});

  @override
  Widget build(BuildContext context) {
    final double scaleValue = MediaQuery.of(context).textScaler.scale(1.3);
    final double aspectRatio = 1.0 + ((scaleValue - 1.0));

    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        enableInfiniteScroll: true,
        viewportFraction: 1 - (3 / 100),
        enlargeCenterPage: true,
        aspectRatio: aspectRatio,
        autoPlayCurve: Curves.easeInOutCubicEmphasized,
      ),
      items: daily.map((daily) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: const AssetImage(
                    '.${KeysOrParams.ASSETS_IMGS_PATH}gradient.jpg',
                  ),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.none,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Colors.transparent,
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            dtToShortNamedDate(daily.dt!),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 30,
                          child: daily.weather?.first.icon != null
                              ? Image.asset(
                                  '${KeysOrParams.OPENWEATHER_ICONS_PATH}${daily.weather?.first.icon}_t@2x.png',
                                )
                              : const Padding(
                                  padding: EdgeInsets.only(left: 30),
                                  child: Icon(
                                    Icons.wifi_off,
                                    size: 50,
                                  ),
                                ),
                        ),
                        Expanded(
                          flex: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    AutoSizeText.rich(
                                      TextSpan(
                                        text: '',
                                        children: [
                                          TextSpan(
                                            text:
                                                'MIN. ${daily.temp?.min?.toStringAsFixed(0)}°C / MAX. ${daily.temp?.max?.toStringAsFixed(0)}°C',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    AutoSizeText.rich(
                                      TextSpan(
                                        text: 'UMIDADE',
                                        children: [
                                          TextSpan(
                                            text: ' ${daily.humidity}%',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    AutoSizeText.rich(
                                      TextSpan(
                                        text: 'CHUVA',
                                        children: [
                                          TextSpan(
                                            text: ' ${daily.rain ?? 0} MM/H',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              '${daily.weather?.first.description!.toUpperCase()}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
