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
  int _selectedIndex = 0;
  MealList _meals;
  DataService service = new DataService();
  TextEditingController controller = new TextEditingController();

  String currentEdit = "";

  _OverviewState() {
    List<MealItem> _mealList = <MealItem>[
      MealItem(name: "Dakgalbi", tasty: false),
      MealItem(name: "Korean BBQ", tasty: false),
      MealItem(name: "Jjimdak", tasty: false),
      MealItem(name: "Bibimbap", tasty: false),
      MealItem(name: "Gimbap", tasty: false),
    ];
    _meals = new MealList.nonempty(_mealList);
  }

  Widget _selectedPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildMealsPage();
        break;
      case 1:
        return _buildEditPage();
        break;
      default:
        return Text(
            "Error: Default case for selected index. This should not happen.");
    }
  }

  void _save() {
    _meals.add(MealItem(name: controller.value.text, tasty: false));
    print("A new meal was saved: " + controller.value.text);
    controller.clear();
  }

  Widget _buildEditPage() {
    controller.
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

  Widget _buildMealsPage() {
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
    // itemBuilder: (BuildContext context, int i) {
    //   if (i.isOdd) return Divider();
    //   final index = i ~/ 2;
    //   return _buildMealRow(_meals.meals[index]);
    // });
  }

  Widget _buildMealRow(MealItem meal) {
    return ListTile(
      title: Text(meal.name),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.center,
        child: _selectedPage(), //_selectedPage.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: "Edit",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
