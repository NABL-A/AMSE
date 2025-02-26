import 'package:flutter/material.dart';
import 'dart:math' as math;

// ==============
// Models
// ==============

math.Random random = new math.Random();

class Tile {
  Color color;

  Tile(this.color);

  Tile.randomColor() : color = Color.fromARGB(
      255, random.nextInt(255), random.nextInt(255), random.nextInt(255));
}

// ==============
// Widgets
// ==============

class TileWidget extends StatelessWidget {
  final Tile tile;

  TileWidget(this.tile);

  @override
  Widget build(BuildContext context) {
    return this.coloredBox();
  }

  Widget coloredBox() {
    return Container(
        color: tile.color,
        child: Padding(
          padding: EdgeInsets.all(70.0),
        ));
  }
}

//void main() => runApp(new MaterialApp(home: PositionedTiles()));

class Exercice6 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PositionedTilesState();
}

class PositionedTilesState extends State<Exercice6> {
  /*List<Widget> tiles =
      List<Widget>.generate(4, (index) => TileWidget(Tile.randomColor()));*/
      List<List<Widget>> tiles = List.generate(
  4,  // Nombre de listes internes
  (rowIndex) => List.generate(
    4,  // Nombre d'éléments par liste interne
    (colIndex) => TileWidget(Tile.randomColor()),
  ),
);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moving Tiles'),
        centerTitle: true,
      ),
      body: Row(children: tiles),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.sentiment_very_satisfied), onPressed: swapTiles),
    );
  }

  swapTiles() {
    setState(() {
      tiles.insert(1, tiles.removeAt(0));
    });
  }
}