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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              meal.description,
              softWrap: true,
            ),
          ),
          meal.picPath != ''
              ? Image.file(File(meal.picPath))
              : Text('no image for this meal'),
        ],
      ),
      // ignore: deprecated_member_use
      tapHeaderToExpand: true,
      // ignore: deprecated_member_use
      hasIcon: true,
      // ignore: deprecated_member_use
      iconColor: Colors.redAccent,
    );
  }
}
