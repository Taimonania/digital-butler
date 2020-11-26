import 'package:flutter/material.dart';
import 'data_helper.dart';
import 'package:expandable/expandable.dart';
import 'dart:io';

class MealExpand extends StatelessWidget {
  final MealItem meal;

  MealExpand(this.meal);

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: Text(meal.name),
      expanded: Column(
        children: [
          Text(
            meal.description,
            softWrap: true,
          ),
          Image.file(File(meal.picPath)),
        ],
      ),
      // ignore: deprecated_member_use
      tapHeaderToExpand: true,
      // ignore: deprecated_member_use
      hasIcon: true,
    );
  }
}
