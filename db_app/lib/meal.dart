import 'package:db_app/overview.dart';
import 'package:flutter/material.dart';
import 'data_helper.dart';
import 'package:expandable/expandable.dart';
import 'dart:io';
import 'maplauncher.dart';

class MealExpand extends StatelessWidget {
  final MealItem meal;
  final int index;
  final OverviewState parent;

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
            Container(
              alignment: Alignment.centerLeft,
              //padding: const EdgeInsets.all(2.0),
              child: meal.coords != ''
                  ? Container(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(Icons.pin_drop),
                        onPressed: () {
                          MapHelper.coordLink(MapHelper.getLat(meal.coords),
                              MapHelper.getLong(meal.coords));
                        },
                        tooltip: 'find in maps',
                        splashColor: Colors.red[100],
                      ),
                    )
                  : Text(
                      '',
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
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      '',
                      softWrap: true,
                    )),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.redAccent[100]),
              child: IconButton(
                splashColor: Colors.red,
                icon: Icon(Icons.delete),
                tooltip: 'Delete this meal',
                onPressed: () {
                  parent.setState(() {
                    DataService().deleteMeal(index);
                  });
                },
              ),
            ),
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
