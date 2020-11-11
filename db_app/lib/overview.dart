import 'package:flutter/material.dart';

class Overview extends StatefulWidget {
  Overview({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  int _selectedIndex = 0;
  List<String> _meals = <String>[
    "Dakgalbi",
    "Korean BBQ",
    "Jjimdak",
    "Bibimbap",
    "Gimbap",
    "Ttoppokki",
    "Cold Noodles",
    "Rice Cake",
  ];

  static List<Widget> _selectedPage = <Widget>[
    Text('Overview Screen: list of meals goes here'),
    Text('Edit Screen: see and edit one meal here'),
  ];

  Widget _buildMeals() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: _meals.length * 2, // *2 because of the dividers
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          return _buildMealRow(_meals[index]);
        });
  }

  Widget _buildMealRow(String meal) {
    return ListTile(
      title: Text(meal),
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
        child: _buildMeals(), //_selectedPage.elementAt(_selectedIndex),
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
