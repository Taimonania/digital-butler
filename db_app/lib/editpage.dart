import 'package:flutter/material.dart';
import 'data_helper.dart';

class EditPage extends StatefulWidget {
  EditPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController controller = new TextEditingController();
  DataService service = new DataService();
  MealList _meals;

  _EditPageState() {
    _meals = new MealList();
  }

  void _save() {
    _meals.add(MealItem(name: controller.value.text, tasty: false));
    print("A new meal was saved: " + controller.value.text);
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Want to add a new meal?',
            ),
            onEditingComplete: _save,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.save),
                onPressed: _save,
                tooltip: 'Save',
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: service.clearMeals,
                tooltip: 'Clear storage',
              )
            ],
          ),
        ),
      ],
    );
  }
}
