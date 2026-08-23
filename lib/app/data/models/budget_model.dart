import 'package:uuid/uuid.dart';

class Budget {
  final String id;
  final String categoryId;
  final String yearMonth; // Format: 'YYYY-MM'
  final double amount;

  Budget({
    required this.id,
    required this.categoryId,
    required this.yearMonth,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'year_month': yearMonth,
      'amount': amount,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'] as String,
      categoryId: map['category_id'] as String,
      yearMonth: map['year_month'] as String,
      amount: (map['amount'] as num).toDouble(),
    );
  }

  factory Budget.create({
    required String categoryId,
    required String yearMonth,
    required double amount,
  }) {
    return Budget(
      id: const Uuid().v4(),
      categoryId: categoryId,
      yearMonth: yearMonth,
      amount: amount,
    );
  }

  static String yearMonthOf(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}';
  }
}
