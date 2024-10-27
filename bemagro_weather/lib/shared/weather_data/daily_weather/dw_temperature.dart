class DWTemperature {
  double? min;
  double? max;
  double? afternoon;
  double? night;
  double? evening;
  double? morning;

  DWTemperature(
      {this.min,
      this.max,
      this.afternoon,
      this.night,
      this.evening,
      this.morning});

  DWTemperature.fromJson(Map<String, dynamic> json) {
    min = json['min'];
    max = json['max'];
    afternoon = json['afternoon'];
    night = json['night'];
    evening = json['evening'];
    morning = json['morning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['min'] = min;
    data['max'] = max;
    data['afternoon'] = afternoon;
    data['night'] = night;
    data['evening'] = evening;
    data['morning'] = morning;
    return data;
  }
}
