import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:localstorage/localstorage.dart';

class MealItem {
  String name;
  String localName;
  String picPath;
  String description;
  String price;
  String coords;

  MealItem(
      {this.name, this.description, this.price, this.localName, this.picPath, this.coords});

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['name'] = name;
    m['local_name'] = localName;
    m['pic_path'] = picPath;
    m['description'] = description;
    m['price'] = price;
    m['meal_location'] = coords;
    return m;
  }
}

/**
 * Here is where I would add a expandable list with a image widget as
 * a child to add images of the meals to the widget
 */
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
  static final DataService _instance = DataService._internal();
  // This is always the current list of meals
  MealList meals;
  LocalStorage _storage;

  // make DataService a singleton
  factory DataService() {
    return _instance;
  }

  DataService._internal() {
    meals = new MealList();
    _storage = new LocalStorage('meals');
    getMeals().then((storedMeals) => meals = storedMeals);
  }

  void addMeal(MealItem meal) {
    meals.add(meal);
    storeMeals(meals);
  }

  void deleteMeal(int index) {
    MealItem meal = meals.meals[index];
    print("Delete meal: ${meal.name}");
    meals.meals.removeAt(index);

    storeMeals(meals);
  }

  void storeMeals(MealList meals) async {
    this.meals = meals;
    await _storage.ready;
    _storage.setItem('meals', meals.toJSONEncodable());
  }

  Future<MealList> getMeals() async {
    await _storage.ready;
    var items = _storage.getItem('meals');
    if (items == null) {
      print("Meals list from the database is null");
      return MealList();
    } else {
      meals.meals = List<MealItem>.from(
        (items as List).map(
          (meal) => MealItem(
              name: meal['name'],
              description: meal['description'],
              price: meal['price'],
              localName: meal['local_name'],
              picPath: meal['pic_path'],
              coords: meal['meal_location']),
        ),
      );
      return meals;
    }
  }

  void clearMeals() async {
    meals.meals.clear();
    await _storage.ready;
    _storage.clear();
  }
}
