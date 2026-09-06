import 'package:flutter/material.dart';
import '../models/category_model.dart';

class MockCategories {
  MockCategories._();

  static const List<CategoryModel> all = [
    CategoryModel(id: 'cat1', name: 'Apartment', icon: Icons.apartment_rounded, count: 128),
    CategoryModel(id: 'cat2', name: 'House', icon: Icons.house_rounded, count: 96),
    CategoryModel(id: 'cat3', name: 'Villa', icon: Icons.villa_rounded, count: 54),
    CategoryModel(id: 'cat4', name: 'Land', icon: Icons.terrain_rounded, count: 22),
    CategoryModel(id: 'cat5', name: 'Office', icon: Icons.corporate_fare_rounded, count: 31),
    CategoryModel(id: 'cat6', name: 'Shop', icon: Icons.storefront_rounded, count: 18, active: false),
    CategoryModel(id: 'cat7', name: 'Commercial', icon: Icons.location_city_rounded, count: 12, active: false),
  ];
}
