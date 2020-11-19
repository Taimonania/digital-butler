import 'package:flutter/material.dart';

class Meal extends StatefulWidget {
  Meal({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MealState createState() => _MealState();
}

class _MealState extends State<Meal> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.title);
  }
}
