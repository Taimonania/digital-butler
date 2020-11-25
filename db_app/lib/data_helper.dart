import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class MealItem {
  String name;
  String localName;
  String picPath;

  MealItem({this.name, this.localName, this.picPath});

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['name'] = name;
    m['local_name'] = localName;
    m['pic_path'] = picPath;

    return m;
  }
}

/**
 *  here is where I would add a expandable list with a image widget as
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
  LocalStorage storage = new LocalStorage('meals');

  void addMeal(MealItem meal) {
    getMeals().then((curMeals) {
      curMeals.add(meal);
      storeMeals(curMeals);
    });
  }

  void storeMeals(MealList meals) async {
    await storage.ready;
    storage.setItem('meals', meals.toJSONEncodable());
  }

  Future<MealList> getMeals() async {
    MealList mealList = new MealList();

    await storage.ready;
    var items = storage.getItem('meals');
    if (items == null) {
      print("Meals list from the database is null");
      return MealList();
    } else {
      mealList.meals = List<MealItem>.from(
        (items as List).map(
          (meal) => MealItem(
              name: meal['name'],
              localName: meal['local_name'],
              picPath: meal['pic_path']),
        ),
      );
      return mealList;
    }
  }

  void clearMeals() async {
    await storage.ready;
    storage.clear();
  }
}
