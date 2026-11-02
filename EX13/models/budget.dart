class Budget {
  const Budget({required this.category, required this.limit});
  final String category;
  final double limit;

  Map<String, dynamic> toJson() => {'category': category, 'limit': limit};

  factory Budget.fromJson(Map<String, dynamic> json) => Budget(
        category: json['category'] as String,
        limit: (json['limit'] as num).toDouble(),
      );
}
