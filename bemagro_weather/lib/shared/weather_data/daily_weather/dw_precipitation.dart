class DWPrecipitation {
  double? total;

  DWPrecipitation({this.total});

  DWPrecipitation.fromJson(Map<String, dynamic> json) {
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    return data;
  }
}
