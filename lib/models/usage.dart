class UsageMetric {
  const UsageMetric({required this.label, required this.used, required this.limit});

  final String label;
  final int used;
  final int limit;

  double get ratio => limit == 0 ? 0 : used / limit;
}

class BillingPlan {
  const BillingPlan({required this.name, required this.price, required this.credits, required this.features});

  final String name;
  final String price;
  final int credits;
  final List<String> features;
}
