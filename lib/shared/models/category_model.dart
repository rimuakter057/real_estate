import 'package:flutter/material.dart';

class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.count,
    this.active = true,
  });

  final String id;
  final String name;
  final IconData icon;
  final int count;
  final bool active;
}
