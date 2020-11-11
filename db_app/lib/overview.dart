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

  Widget _buildEditPage() {
    return Text('Edit Screen: see and edit one meal here');
  }

  Widget _buildMealsPage() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: _meals.length * 2, // length * 2 because of the dividers
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
