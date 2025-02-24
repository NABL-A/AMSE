import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _rotationZ = 0;
  double _rotationX = 0;
  double _scale = 1;
  bool _flip = false;

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
