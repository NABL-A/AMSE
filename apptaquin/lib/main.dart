import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TP2',
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, String>> exercises = const [
    {'title': 'Exercice 1', 'subtitle': 'Show image'},
    {'title': 'Exercice 2a', 'subtitle': 'Rotate & Scale image'},
    {'title': 'Exercice 2b', 'subtitle': 'Animated Rotate & Scale image'},
    {'title': 'Exercice 4', 'subtitle': 'Display a Tile'},
    {'title': 'Exercice 5a', 'subtitle': 'Grid of Colored Boxes'},
    {'title': 'Exercice 5b', 'subtitle': 'Fixed Grid of Cropped image'},
    {'title': 'Exercice 5c', 'subtitle': 'Configurable Taquin Board'},
    {'title': 'Exercice 6a', 'subtitle': 'Moving Tiles'},
    {'title': 'Exercice 6b', 'subtitle': 'Moving Tiles in Grid'},
    {'title': 'Exercice 7', 'subtitle': 'Taquin v1'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TP2'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(exercise['title']!),
              subtitle: Text(exercise['subtitle']!),
              trailing: const Icon(Icons.play_arrow),
              onTap: () {
                Widget page;
                switch (index) {
                  case 0:
                    page = const PageOne();
                    break;
                  case 1:
                    page = PageTwo();
                    break;
                  case 2:
                    page = PageThree();
                    break;
                  case 3:
                    page = PageFour();
                    break;
                  case 4:
                    page = const PageFive();
                    break;
                  case 5:
                    page = const PageSix();
                    break;
                  case 6:
                    page = const PageSeven();
                    break;
                  case 7:
                    page = const PageEight();
                    break;
                  case 8:
                    page = const PageNine();
                    break;
                  case 9:
                    page = const PageTen();
                    break;


                  default:
                    page = const PageOne();
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => page),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ----------------------
// Définition des pages
// ----------------------

class PageOne extends StatelessWidget {
  const PageOne({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 1'),
      ),
      body: const Center(
        child: Image(
          image: NetworkImage('https://picsum.photos/512/1024')
        ),
      ),
    );
  }
}


class PageTwo extends StatefulWidget {
  @override

  PageTwoState createState() => PageTwoState();

}


class PageTwoState extends State<PageTwo> {
  double _rotationZ = 0;
  double _rotationX = 0;
  double _scale = 1;
  bool _flip = false;

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      appBar: AppBar(
        title: Text('TP2'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRect(
              child: Container(
                child: Transform(
                  alignment: Alignment.center, 
                  transform: Matrix4.identity()
                    ..rotateZ(2 * math.pi * _rotationZ)
                    ..rotateX(2 * math.pi * _rotationX)
                    ..scale(2 * _scale),
                  child: Transform.flip(
                    flipX: _flip,
                    child: Image(
                      image: NetworkImage('https://picsum.photos/512/1024'),
                      width: 100,
                    ),
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('RotateX :'),
                Slider(
                  value: _rotationX,
                  min: 0,
                  max: 1,
                  onChanged: (double value) {
                    setState(() {
                      _rotationX = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('RotateZ :'),
                Slider(
                  value: _rotationZ,
                  min: 0,
                  max: 1,
                  onChanged: (double value) {
                    setState(() {
                      _rotationZ = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Mirror :'),
                Checkbox(
                  value: _flip,
                  onChanged: (bool? value) {
                    setState(() {
                      _flip = value ?? false;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Scale :'),
                Slider(
                  value: _scale,
                  min: 0,
                  max: 2,
                  onChanged: (double value) {
                    setState(() {
                      _scale = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PageThree extends StatefulWidget {
  @override

  PageThreeState createState() => PageThreeState();

}


class PageThreeState extends State<PageThree> {
  double _rotationZ = 0;
  double _rotationX = 0;
  double _scale = 1;
  bool _flip = false;

  Timer? _timer;
  int _ticks = 0;

  @override
  void initState() {
    super.initState();
    const duration = Duration(milliseconds: 50);
    _timer = Timer.periodic(duration, animate);
  }
   

    void animate(Timer t) {
    setState(() {
      _rotationZ = (_rotationZ + 0.01) % 1.0;
      _rotationX = (_rotationX + 0.005) % 1.0;
      _scale = 1.0 + 0.5 * math.sin(_ticks * 0.1);
    });
    _ticks++;
    if (_ticks > 200) {
      t.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TP2'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRect(
              child: Container(
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateZ(2 * math.pi * _rotationZ)
                    ..rotateX(2 * math.pi * _rotationX)
                    ..scale(2 * _scale),
                  child: Transform.flip(
                    flipX: _flip,
                    child: Image(
                      image: const NetworkImage('https://picsum.photos/512/1024'),
                      width: 100,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('RotateX :'),
                Slider(
                  value: _rotationX,
                  min: 0,
                  max: 1,
                  onChanged: (double value) {
                    setState(() {
                      _rotationX = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('RotateZ :'),
                Slider(
                  value: _rotationZ,
                  min: 0,
                  max: 1,
                  onChanged: (double value) {
                    setState(() {
                      _rotationZ = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Mirror :'),
                Checkbox(
                  value: _flip,
                  onChanged: (bool? value) {
                    setState(() {
                      _flip = value ?? false;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Scale :'),
                Slider(
                  value: _scale,
                  min: 0,
                  max: 2,
                  onChanged: (double value) {
                    setState(() {
                      _scale = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



class PageFour extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display a Tile as a Cropped Image'),
        centerTitle: true,
      ),
      body: Center(
          child: Column(children: [
        SizedBox(
            width: 150.0,
            height: 150.0,
            child: Container(
                margin: EdgeInsets.all(20.0),
                child: this.createTileWidgetFrom(tile))),
        Container(
            height: 200,
            child: Image.network('https://picsum.photos/512/1024',
                fit: BoxFit.cover))
      ])),
    );
  }

  Widget createTileWidgetFrom(Tile tile) {
    return InkWell(
      child: tile.croppedImageTile(3),
      onTap: () {
        print("tapped on tile");
      },
    );
  }
}

class PageFive extends StatelessWidget {
  const PageFive({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Color> tileColors = [
      Colors.pink.shade300,
      Colors.green.shade300,
      Colors.teal.shade300,
      Colors.red.shade400,
      Colors.lightGreen.shade400,
      Colors.cyan.shade400,
      Colors.red.shade600,
      Colors.lightBlue.shade300,
      Colors.blueGrey.shade300,
    ];

    const double tailleTuile = 100;
    const double espace = 2;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('GridView Example'),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: (tailleTuile * 3) + (espace * 2), 
          ),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: espace,
              mainAxisSpacing: espace,
              mainAxisExtent: tailleTuile, 
            ),
            itemCount: 9,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                color: tileColors[index],
                child: Center(
                  child: Text(
                    'Tile ${index + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class PageSix extends StatelessWidget {
  const PageSix({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Tile> tiles = [
      Tile(imageURL: 'https://picsum.photos/512/1024', alignment: const Alignment(-1.0, -1.0)), 
      Tile(imageURL: 'https://picsum.photos/512/1024', alignment: const Alignment(0.0, -1.0)),  
      Tile(imageURL: 'https://picsum.photos/512/1024', alignment: const Alignment(1.0, -1.0)),  
      Tile(imageURL: 'https://picsum.photos/512/1024', alignment: const Alignment(-1.0, 0.0)),  
      Tile(imageURL: 'https://picsum.photos/512/1024', alignment: const Alignment(0.0, 0.0)),   
      Tile(imageURL: 'https://picsum.photos/512/1024', alignment: const Alignment(1.0, 0.0)),   
      Tile(imageURL: 'https://picsum.photos/512/1024', alignment: const Alignment(-1.0, 1.0)),  
      Tile(imageURL: 'https://picsum.photos/512/1024', alignment: const Alignment(0.0, 1.0)),   
      Tile(imageURL: 'https://picsum.photos/512/1024', alignment: const Alignment(1.0, 1.0)),   
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 2'),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 330,
          ),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              mainAxisExtent: 100,
            ),
            itemCount: 9,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              return tiles[index].croppedImageTile(3);
            },
          ),
        ),
      ),
    );
  }
}

class PageSeven extends StatefulWidget {
  const PageSeven({super.key});

  @override
  State<PageSeven> createState() => _PageSevenState();
}

class _PageSevenState extends State<PageSeven> {
  double numberTiles = 3; 

  List<Tile> generateTiles(int size) {
    List<Tile> tiles = [];
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        double x = -1.0 + (2.0 * j) / (size - 1);
        double y = -1.0 + (2.0 * i) / (size - 1);
        tiles.add(
          Tile(
            imageURL: 'https://picsum.photos/512/1024',
            alignment: Alignment(x, y),
          ),
        );
      }
    }
    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    int gridSize = numberTiles.round();
    final List<Tile> tiles = generateTiles(gridSize);
    
    const double maxWidth = 330.0; 
    const double spacing = 2.0;
    double tileSize = (maxWidth - (spacing * (gridSize - 1))) / gridSize;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 2'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: const BoxConstraints(
                maxWidth: maxWidth, 
              ),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                  mainAxisExtent: tileSize, 
                ),
                itemCount: gridSize * gridSize,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  return tiles[index].croppedImageTile(gridSize);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Size: '),
                Slider(
                  value: numberTiles,
                  min: 3,
                  max: 6,
                  divisions: 3,
                  label: '$gridSize x $gridSize',
                  onChanged: (value) {
                    setState(() {
                      numberTiles = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PageEight extends StatefulWidget {
  const PageEight({super.key});

  @override
  State<PageEight> createState() => _PageEightState();
}

class _PageEightState extends State<PageEight> {
  final math.Random random = math.Random();
  late List<Widget> tiles;

  @override
  void initState() {
    super.initState();
    tiles = List<Widget>.generate(2, (index) => TileWidget(ColorTile.randomColor(random)));
  }

  void swapTiles() {
    setState(() {
      tiles.insert(1, tiles.removeAt(0));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 4'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: tiles,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: swapTiles,
        child: const Icon(Icons.sentiment_very_satisfied),
      ),
    );
  }
}

class PageNine extends StatelessWidget {
  const PageNine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TP2'),
      ),
      body: Center(
        child: Text('Page 9')
      ),
    );
  }
}

class PageTen extends StatelessWidget {
  const PageTen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TP2'),
      ),
      body: Center(
        child: Text('Page 10')
      ),
    );
  }
}


// ----------------------
// Définition des tuiles
// ----------------------


class Tile {
  String imageURL;
  Alignment alignment;

  Tile({required this.imageURL,required this.alignment});

  Widget croppedImageTile(gridSize) {
    return FittedBox(
      fit: BoxFit.fill,
      child: ClipRect(
        child: Container(
          child: Align(
            alignment: this.alignment,
            widthFactor: 1/gridSize,
            heightFactor: 1/gridSize,
            child: Image.network(this.imageURL),
          ),
        ),
      ),
    );
  }
}

Tile tile = new Tile(
    imageURL: 'https://picsum.photos/512/1024', alignment: Alignment(0, 0));

class ColorTile {
  Color color;

  ColorTile(this.color);

  factory ColorTile.randomColor(math.Random random) {
    return ColorTile(Color.fromARGB(
      255,
      random.nextInt(256), 
      random.nextInt(256),
      random.nextInt(256),
    ));
  }
}


class TileWidget extends StatelessWidget {
  final ColorTile tile;

  const TileWidget(this.tile, {super.key});

  @override
  Widget build(BuildContext context) {
    return coloredBox();
  }

  Widget coloredBox() {
    return Container(
      width: 100, 
      height: 100,
      color: tile.color,
      child: const Padding(
        padding: EdgeInsets.all(70.0), 
      ),
    );
  }
}