class Temperature {
  num? day;
  num? min;
  num? max;
  num? night;
  num? eve;
  num? morn;

  Temperature({this.day, this.min, this.max, this.night, this.eve, this.morn});

  Temperature.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    min = json['min'];
    max = json['max'];
    night = json['night'];
    eve = json['eve'];
    morn = json['morn'];
  }

  factory Temperature.placeholder() {
    return Temperature(
      min: 0,
      max: 0,
      day: 0,
      eve: 0,
      morn: 0,
      night: 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['min'] = min;
    data['max'] = max;
    data['night'] = night;
    data['eve'] = eve;
    data['morn'] = morn;
    return data;
  }
}
