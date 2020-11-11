import 'package:flutter/material.dart';

import 'overview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Butler Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Overview(title: 'Digital Butler'),
    );
  }
}

// class MyHomePage extends StatelessWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//   final String title;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(this.title),
//       ),
//       body: Container(
//         alignment: Alignment.center,
//         child: Text('List of meals goes here'),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: "home",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.edit),
//             label: "edit",
//           ),
//         ],
//         //currentIndex: 0,
//         //selectedItemColor: Colors.blue,
//       ),
//     );
//   }
// }
