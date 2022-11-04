class PickupPoint {
  final String location_id;
  final String address;
  final String latitude;
  final String longitude;
  final String user_id;

  PickupPoint({required this.location_id,required this.address,required this.latitude,required this.longitude,required this.user_id});

  static PickupPoint fromJson(json) => PickupPoint(
    location_id: json['location_id'],
    address: json['address'],
    latitude: json['latitude'],
    longitude: json['longitude'],
    user_id: json['user_id'],
  );
}