class DWCloudCover {
  double? afternoon;

  DWCloudCover({this.afternoon});

  DWCloudCover.fromJson(Map<String, dynamic> json) {
    afternoon = json['afternoon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['afternoon'] = afternoon;
    return data;
  }
}
