import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class MealItem {
  String name;
  bool tasty;

  MealItem({this.name, this.tasty});

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['name'] = name;
    m['tasty'] = tasty;

    return m;
  }
}

class MealList {
  List<MealItem> meals;

  MealList() {
    meals = new List();
  }

  MealList.nonempty(List<MealItem> mealList) {
    meals = mealList;
  }

  void add(MealItem item) {
    meals.add(item);
  }

  toJSONEncodable() {
    return meals.map((meal) {
      return meal.toJSONEncodable();
    }).toList();
  }
}

class DataService {
  LocalStorage storage = new LocalStorage('meals');

  void storeMeals(MealList meals) async {
    await storage.ready;
    storage.setItem('meals', meals);
  }

  Future<MealList> getMeals() async {
    await storage.ready;
    return storage.getItem('meals');
  }

  void clearMeals() async {
    await storage.ready;
    storage.clear();
  }
}
