import 'category_model.dart';
import 'package:uuid/uuid.dart';

class Expense {
  final String? id;
  final String name;
  final String type; // Category ID
  final Category? category; // Joined data
  final String transactionType; // 'income' or 'expense'
  final DateTime dateTime;
  final double price;

  const Expense({
    this.id,
    required this.name,
    required this.type,
    this.category,
    required this.transactionType,
    required this.dateTime,
    required this.price,
  });

  // Create Expense (Simplified, category is now just an ID)
  factory Expense.create({
    required String name,
    required String categoryId,
    required String transactionType,
    required DateTime dateTime,
    required double price,
  }) {
    return Expense(
      id: const Uuid().v4(),
      name: name,
      type: categoryId,
      transactionType: transactionType,
      dateTime: dateTime,
      price: price,
    );
  }

  // Convert Expense to Map for database operations
  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'transaction_type': transactionType,
      'date_time': dateTime.toIso8601String(),
      'price': price,
    };
  }

  // Create Expense from database map
  factory Expense.fromDbMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String?,
      name: map['name'] as String,
      type: map['type'] as String,
      transactionType: map['transaction_type'] as String? ?? 'expense',
      dateTime: DateTime.parse(map['date_time'] as String),
      price: (map['price'] as num).toDouble(),
    );
  }

  // Convert JSON to Expense
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String?,
      name: json['name'] as String,
      type: json['type'] as String,
      transactionType: json['transaction_type'] as String? ?? 'expense',
      dateTime: DateTime.parse(json['date_time'] as String),
      price: (json['price'] as num).toDouble(),
    );
  }

  // Convert Expense to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'transaction_type': transactionType,
      'date_time': dateTime.toIso8601String(),
      'price': price,
    };
  }

  // Copy with new values
  Expense copyWith({
    String? id,
    String? name,
    String? type,
    Category? category,
    String? transactionType,
    DateTime? dateTime,
    double? price,
  }) {
    return Expense(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      category: category ?? this.category,
      transactionType: transactionType ?? this.transactionType,
      dateTime: dateTime ?? this.dateTime,
      price: price ?? this.price,
    );
  }

  @override
  String toString() {
    return 'Expense(id: $id, name: $name, type: $type, category: $category, transactionType: $transactionType, dateTime: $dateTime, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Expense &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.transactionType == transactionType &&
        other.dateTime == dateTime &&
        other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ type.hashCode ^ transactionType.hashCode ^ dateTime.hashCode ^ price.hashCode;
  }
}
