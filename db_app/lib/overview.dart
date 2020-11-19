import 'dart:developer';

import 'package:flutter/material.dart';
import 'data_helper.dart';

class Overview extends StatefulWidget {
  Overview({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  MealList _meals;
  DataService service = new DataService();
  TextEditingController controller = new TextEditingController();

  String currentEdit = "";

  _OverviewState() {
    _meals = MealList();

    _meals.add(MealItem(name: "Dakgalbi", tasty: false));
    _meals.add(MealItem(name: "Korean BBQ", tasty: false));
    _meals.add(MealItem(name: "Jjimdak", tasty: false));
    _meals.add(MealItem(name: "Bibimbap", tasty: false));
    _meals.add(MealItem(name: "Gimbap", tasty: false));
  }

  Widget _buildMealRow(MealItem meal) {
    return ListTile(
      title: Text(meal.name),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MealList>(
        future: service.getMeals(),
        builder: (BuildContext context, AsyncSnapshot<MealList> snapshot) {
          if (snapshot.hasData) {
            _meals = snapshot.data;
          }
          return ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount:
                  _meals.meals.length * 2, // length * 2 because of the dividers
              itemBuilder: (BuildContext context, int i) {
                return GestureDetector(
                  child: (() {
                    if (i.isOdd) return Divider();
                    final index = i ~/ 2;
                    return _buildMealRow(_meals.meals[index]);
                  }()),
                  onTap: () => Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text(i.toString()))),
                );
              });
        });
  }
}
