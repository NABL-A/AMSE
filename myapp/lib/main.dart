import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

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
        items: [
          BottomNavigationBarItem(
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
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class GalleryItem {
  final String text;
  final String url;

  GalleryItem(this.text, this.url);
}

class _HomePageState extends State<HomePage> {
  List<GalleryItem> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGalleryItems();
  }

  Future<void> fetchGalleryItems() async {
    final baseUrl = 'https://bindingofisaacrebirth.fandom.com/fr/wiki';
    final url = '$baseUrl/Binding_of_Isaac:_Rebirth_Wiki';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var document = html_parser.parse(response.body);
        var items = document.querySelectorAll('.gallerybox');

        setState(() {
          _items = items
              .map((element) {
                // Construisez l'URL complète en utilisant le texte de chaque élément
                String itemUrl =
                    '$baseUrl/${element.text.trim().replaceAll(' ', '_')}';
                return GalleryItem(element.text.trim(), itemUrl);
              })
              .where((item) => item.text.isNotEmpty)
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(item: {
                        'title': _items[index].text,
                        'url': _items[index].url,
                      }),
                    ),
                  );
                },
                child: Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      _items[index].text,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
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

class DetailPage extends StatefulWidget {
  final Map<String, String> item;

  const DetailPage({super.key, required this.item});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<String> _paragraphs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetailPage();
  }

  Future<void> fetchDetailPage() async {
    try {
      final response = await http.get(Uri.parse(widget.item['url']!));

      if (response.statusCode == 200) {
        var document = html_parser.parse(response.body);

        var content = document.querySelector('.mw-parser-output');
        if (content != null) {
          var paragraphs = content.querySelectorAll('p');
          setState(() {
            _paragraphs = paragraphs
                .map((p) => p.text.trim())
                .where((text) => text.isNotEmpty)
                .toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.item['title']!)),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: _paragraphs.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      _paragraphs[index],
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
