import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'editpage.dart';
import 'overview.dart';
import 'translation/input.dart';
import 'translation/output.dart';


void main() => runApp(MaterialApp(home:Splash()));

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash>{
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 6,
      backgroundColor: Colors.white,
      image: Image.asset('assets/loading.gif'),
      loaderColor: Colors.red,
      useLoader: true,
      photoSize: 140.0,
      navigateAfterSeconds: MyApp(),
    );
//    throw UnimplementedError();
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
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
