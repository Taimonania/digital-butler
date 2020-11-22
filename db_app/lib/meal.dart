import 'package:flutter/material.dart';
import 'data_helper.dart';
import 'package:expandable/expandable.dart';

class MealExpand extends StatelessWidget {
  final MealItem meal;

  MealExpand(this.meal);

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: Text(meal.name),
      expanded: Text(
        "this is where all the juicy details are \nmore details \n even",
        softWrap: true,
      ),
      // ignore: deprecated_member_use
      tapHeaderToExpand: true,
      // ignore: deprecated_member_use
      hasIcon: true,
    );
  }
}
