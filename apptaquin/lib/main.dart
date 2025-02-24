import 'package:flutter/material.dart';
import 'Exercice1.dart';
import 'Exercice2.dart';
import 'Exercice4.dart';
import 'Exercice5.dart';
import 'Exercice6.dart';
import 'Exercice7.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Directionality Example')),
      body: ListView(
  children: [
    Card(
      child: ListTile(
        leading: Icon(Icons.access_alarm),
        title: Text("Exercice1"),
        subtitle: Text('Wake up early!'),
        onTap: () {
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Exercice2(),
          ),);
          // Action when tapped
        },
      ),

    ),
    Card(
      child: ListTile(
        leading: Icon(Icons.settings),
        title: Text("Exercice 2"),
        subtitle: Text('App settings'),
        onTap: () {
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Exercice2(),
          ),);
        },

      ),
    ),
    
    Card(
      child: ListTile(
        leading: Icon(Icons.settings),
        title: Text("Exercice 4"),
        subtitle: Text('App settings'),
        onTap: () {
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Exercice4(),
          ),);
        },
      ),
    ),
    Card(
      child: ListTile(
        leading: Icon(Icons.settings),
        title: Text("Exercice 5"),
        subtitle: Text('App settings'),
        onTap: () {
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Exercice5(),
          ),);
        },
      ),
    ),
    Card(
      child: ListTile(
        leading: Icon(Icons.settings),
        title: Text("Exercice 6"),
        subtitle: Text('App settings'),
        onTap: () {
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Exercice6(),
          ),);
        },
      ),
    ),
    Card(
      child: ListTile(
        leading: Icon(Icons.settings),
        title: Text("Exercice 2"),
        subtitle: Text('App settings'),
        onTap: () {
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Exercice2(),
          ),);
        },
      ),
    ),
    Card(
      child: ListTile(
        leading: Icon(Icons.settings),
        title: Text("Exercice 7"),
        subtitle: Text('App settings'),
        onTap: () {
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Exercice7(),
          ),);
        },
      ),
    ),
  ],
)

    );
  }
}
