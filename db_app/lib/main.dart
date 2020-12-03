import 'package:flutter/material.dart';

import 'editpage.dart';
import 'overview.dart';
import 'translation/input.dart';
import 'translation/output.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Butler Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MainView(title: 'Digital Butler'),
    );
  }
}

class MainView extends StatefulWidget {
  MainView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  // index for the currently selected bottom menu
  int _selectedIndex = 0;
  Overview overview;

  _MainViewState() {
    overview = Overview();
  }

  Widget _selectedPage() {
    switch (_selectedIndex) {
      case 0:
        return Overview(title: widget.title);
        break;
      case 1:
        return EditPage(title: widget.title);
        break;
      case 2:
        return InputScreen();
        break;
      default:
        return Text(
            "Error: Default case for selected index. This should not happen.");
    }
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
            icon: Icon(Icons.add),
            label: "New",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.translate),
            label: "Translation",
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.red[100],
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }
}
