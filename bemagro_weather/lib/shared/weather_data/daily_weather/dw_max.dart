class DWMax {
  double? speed;
  double? direction;

  DWMax({this.speed, this.direction});

  DWMax.fromJson(Map<String, dynamic> json) {
    speed = json['speed'];
    direction = json['direction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['speed'] = speed;
    data['direction'] = direction;
    return data;
  }
}
