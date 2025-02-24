import 'dart:math';
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
                    page = const PageFour();
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
                    ..rotateZ(2 * pi * _rotationZ)
                    ..rotateX(2 * pi * _rotationX)
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
      _scale = 1.0 + 0.5 * sin(_ticks * 0.1);
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
                    ..rotateZ(2 * pi * _rotationZ)
                    ..rotateX(2 * pi * _rotationX)
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
  const PageFour({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 4'),
      ),
      body: const Center(
        child: Text(
          'Contenu de la Page 4',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class PageFive extends StatelessWidget {
  const PageFive({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 1'),
      ),
      body: const Center(
        child: Text(
          'Contenu de la Page 1',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class PageSix extends StatelessWidget {
  const PageSix({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 2'),
      ),
      body: const Center(
        child: Text(
          'Contenu de la Page 2',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class PageSeven extends StatelessWidget {
  const PageSeven({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 3'),
      ),
      body: const Center(
        child: Text(
          'Contenu de la Page 3',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class PageEight extends StatelessWidget {
  const PageEight({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 4'),
      ),
      body: const Center(
        child: Text(
          'Contenu de la Page 4',
          style: TextStyle(fontSize: 24),
        ),
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
        title: const Text('Page 1'),
      ),
      body: const Center(
        child: Text(
          'Contenu de la Page 1',
          style: TextStyle(fontSize: 24),
        ),
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
        title: const Text('Page 2'),
      ),
      body: const Center(
        child: Text(
          'Contenu de la Page 2',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

