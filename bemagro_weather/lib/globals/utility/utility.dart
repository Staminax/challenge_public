library;

import 'dart:io';

String dtToFullNamedDate(DateTime date) {
  final Map<String, String> dayData = {
    "1": "Segunda-Feira",
    "2": "Terça-Feira",
    "3": "Quarta-Feira",
    "4": "Quinta-Feira",
    "5": "Sexta-Feira",
    "6": "Sábado",
    "7": "Domingo"
  };

  final Map<String, String> monthData = {
    "1": "Janeiro",
    "2": "Fevereiro",
    "3": "Março",
    "4": "Abril",
    "5": "Maio",
    "6": "Junho",
    "7": "Julho",
    "8": "Agosto",
    "9": "Setembro",
    "10": "Outubro",
    "11": "Novembro",
    "12": "Dezembro"
  };

  return "${dayData['${date.weekday}']}, ${date.day} de ${monthData['${date.month}']}";
}

String dtToShortNamedDate(int ts) {
  final Map<String, String> dayData = {
    "1": "Segunda-Feira",
    "2": "Terça-Feira",
    "3": "Quarta-Feira",
    "4": "Quinta-Feira",
    "5": "Sexta-Feira",
    "6": "Sábado",
    "7": "Domingo"
  };

  final Map<String, String> monthData = {
    "1": "Janeiro",
    "2": "Fevereiro",
    "3": "Março",
    "4": "Abril",
    "5": "Maio",
    "6": "Junho",
    "7": "Julho",
    "8": "Agosto",
    "9": "Setembro",
    "10": "Outubro",
    "11": "Novembro",
    "12": "Dezembro"
  };

  DateTime date = DateTime.fromMillisecondsSinceEpoch(ts * 1000);

  return "${dayData['${date.weekday}']}, ${date.day} de ${monthData['${date.month}']}";
}

String getCloudCoverageDescription(int cloudPercentage) {
  int cloudCoverageOktas = (cloudPercentage * 8 / 100).round();

  switch (cloudCoverageOktas) {
    case 0:
      return 'CÉU LIMPO';
    case 1 || 2:
      return 'POUCAS NUVENS';
    case 3 || 4:
      return 'PARCIALMENTE NUBLADO';
    case 5 || 6:
      return 'PREDOMINANTEMENTE NUBLADO';
    case 7:
      return 'MUITO NUBLADO';
    case 8:
      return 'NUBLADO';
    default:
      return 'SEM PREVISÃO';
  }
}

Future<bool> isOnline() async {
  try {
    List<InternetAddress> result = await InternetAddress.lookup('example.com');
    return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
  } catch (e) {
    return false;
  }
}

String namedDate(int timestamp) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return dtToFullNamedDate(date);
}

int nowToTimestamp() {
  return DateTime.now().millisecondsSinceEpoch ~/ 1000;
}

String sanitize(String input) {
  final replacementMap = {
    'á': 'a', 'à': 'a', 'ã': 'a', 'â': 'a', 'ä': 'a',
    'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
    'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i',
    'ó': 'o', 'ò': 'o', 'õ': 'o', 'ô': 'o', 'ö': 'o',
    'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u',
    'ç': 'c',
    'ñ': 'n',
    //
  };

  final StringBuffer normalized = StringBuffer();

  for (int i = 0; i < input.length; i++) {
    final char = input[i];
    normalized.write(replacementMap[char] ?? char);
  }

  return normalized.toString();
}

int simpleDateToTimestamp(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  dateTime = dateTime.toUtc().add(const Duration(hours: -3));

  return dateTime.millisecondsSinceEpoch;
}

String timestampToSimpleDate(int timestamp, {bool isInSeconds = false}) {
  if (isInSeconds) {
    timestamp *= 1000;
  }

  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

  String year = dateTime.year.toString();
  String month = dateTime.month.toString().padLeft(2, '0');
  String day = dateTime.day.toString().padLeft(2, '0');

  return '$year-$month-$day';
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
