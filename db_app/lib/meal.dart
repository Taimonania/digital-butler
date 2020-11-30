import 'package:db_app/overview.dart';
import 'package:flutter/material.dart';
import 'data_helper.dart';
import 'package:expandable/expandable.dart';
import 'dart:io';

class MealExpand extends StatelessWidget {
  final MealItem meal;
  final int index;
  OverviewState parent;

  MealExpand(this.meal, this.index, this.parent);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ExpandablePanel(
        header: Row(children: [
          Text(
            meal.name,
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ]),
        expanded: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(2.0),
              child: Text(
                meal.description + "\n",
                softWrap: true,
              ),
            ),
            meal.picPath != ''
                ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 3.0, color: Colors.red[100]),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(4.0),
                    child: Image.file(
                      File(meal.picPath),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 2.0, color: Colors.red[100])),
                    ),
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      'no image for this meal',
                      softWrap: true,
                      style: TextStyle(fontStyle: FontStyle.italic),
                    )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.delete),
                  tooltip: 'Delete this meal',
                  onPressed: () {
                    parent.setState(() {
                      DataService().deleteMeal(index);
                    });
                  },
                ),
              ],
            )
          ],
        ),
        // ignore: deprecated_member_use
        tapHeaderToExpand: true,
        // ignore: deprecated_member_use
        hasIcon: true,
        // ignore: deprecated_member_use
        iconColor: Colors.redAccent,
      ),
    );
  }
}
