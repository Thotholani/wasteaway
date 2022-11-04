class SubscriptionPlan {
  final String subscription_plan;
  final String description;
  final String fee;
  final String number_of_pickups;
  final String billing_time;

  SubscriptionPlan({required this.subscription_plan,required this.description,required this.fee,required this.number_of_pickups,required this.billing_time});

  static SubscriptionPlan fromJson(json) => SubscriptionPlan(
    subscription_plan: json['subscription_plan'],
    description: json['description'],
    fee: json['fee'],
    number_of_pickups: json['number_of_pickups'],
    billing_time: json['billing_time'],
  );
}