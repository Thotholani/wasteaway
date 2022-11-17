class SubscriptionPlan {
  final String package_plan;
  final String price;
  final String number_of_pickups;
  final String billing_time;

  SubscriptionPlan({required this.package_plan,required this.price,required this.number_of_pickups,required this.billing_time});

  static SubscriptionPlan fromJson(json) => SubscriptionPlan(
    package_plan: json['package_plan'],
    price: json['price'],
    number_of_pickups: json['number_of_pickups'],
    billing_time: json['billing_time'],
  );
}