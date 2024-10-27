class City {
  final String uf;
  final String name;
  final double lon;
  final double lat;

  City({
    this.uf = '',
    this.name = '',
    this.lon = 0,
    this.lat = 0,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      uf: json['uf'],
      name: json['name'],
      lon: json['lon'].toDouble(),
      lat: json['lat'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uf': uf,
      'name': name,
      'lon': lon,
      'lat': lat,
    };
  }
}
