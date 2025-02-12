import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
//import 'package:html/dom.dart' as html_dom;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scraping Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    FavoritePage(),
    SearchPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromARGB(1, 54, 1, 63),
          items: [
            BottomNavigationBarItem(
              backgroundColor: Colors.red,
              icon: Image.asset('assets/stuff.webp'),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/heart.webp'),
              label: 'Favoris',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/compass.webp'),
              label: 'Recherche',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _titles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTitles();
  }

  Future<void> fetchTitles() async {
    final url = 'https://bindingofisaacrebirth.fandom.com/wiki/Achievements';
    try {
      // Ajout d'un header User-Agent pour simuler un navigateur
      final response = await http.get(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        var document = html_parser.parse(response.body);
        // Utilisation d'un sélecteur qui cible les éléments de titre
        var titles = document.querySelectorAll('span.mw-headline');

        setState(() {
          _titles = titles.map((element) => element.text.trim()).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        print('Erreur lors du chargement de la page : ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Erreur : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _titles.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_titles[index]),
              );
            },
          );
  }
}

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Favorite Page', style: TextStyle(fontSize: 24)),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Search Page', style: TextStyle(fontSize: 24)),
    );
  }
}
