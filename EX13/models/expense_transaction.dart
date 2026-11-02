enum TransactionType { income, expense }

class ExpenseTransaction {
  const ExpenseTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
    this.note = '',
    this.paymentMethod = 'Cash',
  });

  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final TransactionType type;
  final String note;
  final String paymentMethod;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'amount': amount,
        'category': category,
        'date': date.toIso8601String(),
        'type': type.name,
        'note': note,
        'paymentMethod': paymentMethod,
      };

  factory ExpenseTransaction.fromJson(Map<String, dynamic> json) {
    return ExpenseTransaction(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
      type: TransactionType.values.firstWhere(
        (value) => value.name == json['type'],
        orElse: () => TransactionType.expense,
      ),
      note: json['note'] as String? ?? '',
      paymentMethod: json['paymentMethod'] as String? ?? 'Cash',
    );
  }
}
