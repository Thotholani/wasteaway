class Collection  {
  final String collectionId;
  // final String collector;
  final String collectionDate;
  final String fee;
  final String status;
  final String address;

  Collection({required this.collectionId, required this.collectionDate, required this.fee, required this.status, required this.address});

  static Collection fromJson(json) => Collection(
    collectionId: json['collection_id'],
    collectionDate: json['collection_date'],
    fee: json['service_fee'],
    status: json['status'],
    // collector: json['collector_id'],
    address: json['address'],
  );
}