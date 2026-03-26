import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Category {
  final String id;
  final String label;
  final int colorValue;
  final String icon;

  Category({
    required this.id,
    required this.label,
    required this.colorValue,
    required this.icon,
  });

  Color get color => Color(colorValue);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'color_value': colorValue,
      'icon': icon,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      label: map['label'] as String,
      colorValue: map['color_value'] as int,
      icon: map['icon'] as String,
    );
  }

  factory Category.create({
    required String label,
    required Color color,
    required String icon,
  }) {
    return Category(
      id: const Uuid().v4(),
      label: label,
      colorValue: color.value,
      icon: icon,
    );
  }
}
