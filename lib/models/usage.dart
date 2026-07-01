class UsageMetric {
  const UsageMetric({required this.label, required this.used, required this.limit});

  final String label;
  final int used;
  final int limit;

  double get ratio => limit == 0 ? 0 : used / limit;

  factory UsageMetric.fromJson(Map<String, dynamic> json) {
    return UsageMetric(
      label: (json['label'] ?? json['name'] ?? json['metric'] ?? 'Usage').toString(),
      used: _parseInt(json['used'] ?? json['current'] ?? json['value']),
      limit: _parseInt(json['limit'] ?? json['max'] ?? json['quota']),
    );
  }

  static int _parseInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class BillingPlan {
  const BillingPlan({required this.name, required this.price, required this.credits, required this.features});

  final String name;
  final String price;
  final int credits;
  final List<String> features;

  factory BillingPlan.fromJson(Map<String, dynamic> json) {
    final rawFeatures = json['features'] ?? json['items'] ?? const <dynamic>[];
    return BillingPlan(
      name: (json['name'] ?? json['plan'] ?? 'Plan actif').toString(),
      price: (json['price'] ?? json['amount'] ?? json['label'] ?? '').toString(),
      credits: UsageMetric._parseInt(json['credits'] ?? json['remainingCredits'] ?? json['balance']),
      features: rawFeatures is List ? rawFeatures.map((item) => item.toString()).toList() : <String>[],
    );
  }
}
