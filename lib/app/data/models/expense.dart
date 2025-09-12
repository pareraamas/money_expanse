import 'package:uuid/uuid.dart';

import 'expense_type.dart';

class Expense {
  final String? id;
  final String name;
  final String type; // Store as String for database compatibility
  final DateTime dateTime;
  final double price;

  const Expense({this.id, required this.name, required this.type, required this.dateTime, required this.price});

  // Create Expense with ExpenseType
  factory Expense.create({required String name, required ExpenseType type, required DateTime dateTime, required double price}) {
    return Expense(id: Uuid().v4(), name: name, type: type.toShortString(), dateTime: dateTime, price: price);
  }

  // Convert Expense to Map for database operations
  Map<String, dynamic> toDbMap() {
    return {'id': id, 'name': name, 'type': type, 'date_time': dateTime.toIso8601String(), 'price': price};
  }

  // Create Expense from database map
  factory Expense.fromDbMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String?,
      name: map['name'] as String,
      type: map['type'] as String,
      dateTime: DateTime.parse(map['date_time'] as String),
      price: (map['price'] as num).toDouble(),
    );
  }

  // Get ExpenseType
  ExpenseType get expenseType => ExpenseType.fromString(type);

  // Convert JSON to Expense
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String?,
      name: json['name'] as String,
      type: json['type'] as String,
      dateTime: DateTime.parse(json['date_time'] as String),
      price: (json['price'] as num).toDouble(),
    );
  }

  // Convert Expense to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'type': type, 'date_time': dateTime.toIso8601String(), 'price': price};
  }

  // Copy with new values
  Expense copyWith({String? id, String? name, String? type, DateTime? dateTime, double? price}) {
    return Expense(id: id ?? this.id, name: name ?? this.name, type: type ?? this.type, dateTime: dateTime ?? this.dateTime, price: price ?? this.price);
  }

  @override
  String toString() {
    return 'Expense(id: $id, name: $name, type: $type, dateTime: $dateTime, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Expense && other.id == id && other.name == name && other.type == type && other.dateTime == dateTime && other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ type.hashCode ^ dateTime.hashCode ^ price.hashCode;
  }
}
