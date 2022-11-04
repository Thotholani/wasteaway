class Collector {
  final String name;
  final String collector_id;
  final String rating;

  Collector({required this.name, required this.collector_id, required this.rating});

  static Collector fromJson(json) => Collector(
    name: json['name'],
    collector_id: json['collector_id'],
    rating: json['rating'],
  );
}