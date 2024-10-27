import 'package:bemagro_weather/globals/theme/app_theme.dart';
import 'package:bemagro_weather/modules/entrypoint/entrypoint_page.dart';
import 'package:bemagro_weather/shared/database/database.dart';
import 'package:bemagro_weather/shared/database/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

class HeatbeatWeather extends ConsumerWidget {
  const HeatbeatWeather({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    initDb();
    initializeDateFormatting('pt_BR', null);

    return MaterialApp(
      builder: (context, child) {
        final MediaQueryData mediaQueryData = MediaQuery.of(context);

        final TextScaler textScaler = mediaQueryData.textScaler.clamp(
          minScaleFactor: 1.0,
          maxScaleFactor: 1.3,
        );

        return MediaQuery(
          data: mediaQueryData.copyWith(textScaler: textScaler),
          child: child!,
        );
      },
      title: 'Hotspots',
      theme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      home: const EntrypointPage(),
    );
  }

  void initDb() {
    DbHelper _ = BemAgroWeatherDatabase.instance;
    Future.delayed(const Duration(seconds: 1));
  }
}
