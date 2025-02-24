import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edmund <3',
      theme: ThemeData(fontFamily: 'Outfit'),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Outfit',
      ),
      themeMode: ThemeMode.system,
      home: const MainScreen(),
    );
  }
}

class Game {
  final String title;
  final String image;
  final Map<String, List<Track>> variants;

  Game({required this.title, required this.image, required this.variants});

  factory Game.fromJson(Map<String, dynamic> json) {
    Map<String, List<Track>> variantsMap = {};
    (json["variants"] as Map<String, dynamic>).forEach((variantKey, tracks) {
      variantsMap[variantKey] = (tracks as List)
          .map((trackJson) => Track.fromJson(trackJson))
          .toList();
    });
    return Game(
      title: json["title"],
      image: json["image"],
      variants: variantsMap,
    );
  }
}

class Track {
  final String title;
  final String url;

  Track({required this.title, required this.url});

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(title: json["title"], url: json["url"]);
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  Map<String, Set<String>> favoriteTracks = {};

  void toggleFavorite(String gameTitle, String trackTitle) {
    setState(() {
      if (!favoriteTracks.containsKey(gameTitle)) {
        favoriteTracks[gameTitle] = {};
      }
      if (favoriteTracks[gameTitle]!.contains(trackTitle)) {
        favoriteTracks[gameTitle]!.remove(trackTitle);
        if (favoriteTracks[gameTitle]!.isEmpty) {
          favoriteTracks.remove(gameTitle);
        }
      } else {
        favoriteTracks[gameTitle]!.add(trackTitle);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(
        toggleFavorite: toggleFavorite,
        favoriteTracks: favoriteTracks,
      ),
      FavoritePage(
        favoriteTracks: favoriteTracks,
        toggleFavorite: toggleFavorite,
      ),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
        ],
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
  final Function(String, String) toggleFavorite;
  final Map<String, Set<String>> favoriteTracks;

  const HomePage({
    super.key,
    required this.toggleFavorite,
    required this.favoriteTracks,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Game>> _futureGames;

  @override
  void initState() {
    super.initState();
    _futureGames = loadGames();
  }

  Future<List<Game>> loadGames() async {
    final jsonString = await rootBundle.loadString('assets/data.json');
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    final List<dynamic> gamesJson = jsonMap["games"];
    return gamesJson.map((gameJson) => Game.fromJson(gameJson)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edmund <3")),
      body: FutureBuilder<List<Game>>(
        future: _futureGames,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          } else {
            final games = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                "assets/edmund.jpg",
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 16,
                                    color: Colors.white,
                                    height: 1.5,
                                  ),
                                  children: const [
                                    TextSpan(
                                      text:
                                          "Edmund McMillen (né le 2 mars 1980 à Santa Cruz en Californie) est un game designer américain. ",
                                    ),
                                    TextSpan(
                                      text:
                                          "Créateur de Gish, Super Meat Boy et The Binding of Isaac, ",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text:
                                          "il se distingue par son style visuel unique et ses systèmes de jeu innovants. Outre les jeux vidéo, il réalise aussi des comics (il en aurait réalisé plus d'une quinzaine selon son site). Parmi les particularités de ses créations se dégagent l'importance du level design et la volonté de proposer une courbe de difficulté récompensant les joueurs les plus acharnés, notamment par le schéma classique «risque/récompense». ",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Cette application permet de donner un avant goût des trois oeuvres m'ayant le plus marqué de ce monsieur à travers les bandes sons originales de ces jeux. Parfois mélancholiques, souvent oppressantes et quelques fois dansantes, on se demande comment de telles musiques peuvent servir l'ambiance de ses si triste jeux",
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            color: Colors.white,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.3,
                      ),
                      itemCount: games.length,
                      itemBuilder: (context, index) {
                        final game = games[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GameDetailPage(
                                  game: game,
                                  toggleFavorite: widget.toggleFavorite,
                                  favoriteTracks: widget.favoriteTracks,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  game.image,
                                  width: 130,
                                  height: 130,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  game.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class GameDetailPage extends StatelessWidget {
  final Game game;
  final Function(String, String) toggleFavorite;
  final Map<String, Set<String>> favoriteTracks;

  const GameDetailPage({
    super.key,
    required this.game,
    required this.toggleFavorite,
    required this.favoriteTracks,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(game.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                if (game.variants.keys.length > 1) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Choose the OST"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: game.variants.keys.map((variantKey) {
                          return ListTile(
                            title: Text("OST $variantKey"),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MusicDetailPage(
                                    game: game,
                                    variant: variantKey,
                                    toggleFavorite: toggleFavorite,
                                    favoriteTracks: favoriteTracks,
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  );
                } else if (game.variants.containsKey("default")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MusicDetailPage(
                        game: game,
                        variant: "default",
                        toggleFavorite: toggleFavorite,
                        favoriteTracks: favoriteTracks,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text("No Music content available for this game")),
                  );
                }
              },
              icon: const Icon(Icons.music_note, size: 32),
              label: const Text("Music", style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              ),
            ),
            const SizedBox(height: 20),
            if (game.title == "The Binding of Isaac")
              ElevatedButton.icon(
                onPressed: () async {
                  final Uri url = Uri.parse(
                      "https://bindingofisaac.fandom.com/wiki/The_Binding_of_Isaac_Artbook");
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Impossible d'ouvrir l'URL")),
                    );
                  }
                },
                icon: const Icon(Icons.image, size: 32),
                label: const Text("Artwork", style: TextStyle(fontSize: 20)),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class MusicDetailPage extends StatefulWidget {
  final Game game;
  final String variant;
  final Function(String, String) toggleFavorite;
  final Map<String, Set<String>> favoriteTracks;

  const MusicDetailPage({
    super.key,
    required this.game,
    required this.variant,
    required this.toggleFavorite,
    required this.favoriteTracks,
  });

  @override
  _MusicDetailPageState createState() => _MusicDetailPageState();
}

class _MusicDetailPageState extends State<MusicDetailPage> {
  late List<Track> tracks;

  @override
  void initState() {
    super.initState();
    tracks = widget.game.variants[widget.variant] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Musics - ${widget.game.title}")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.5,
          ),
          itemCount: tracks.length,
          itemBuilder: (context, index) {
            final track = tracks[index];
            return MusicCard(
              gameTitle: widget.game.title,
              title: track.title,
              soundCloudUrl: track.url,
              isFavorite: widget.favoriteTracks[widget.game.title]
                      ?.contains(track.title) ??
                  false,
              toggleFavorite: widget.toggleFavorite,
            );
          },
        ),
      ),
    );
  }
}

class MusicCard extends StatefulWidget {
  final String gameTitle;
  final String title;
  final String soundCloudUrl;
  final bool isFavorite;
  final Function(String, String) toggleFavorite;

  const MusicCard({
    super.key,
    required this.gameTitle,
    required this.title,
    required this.soundCloudUrl,
    required this.isFavorite,
    required this.toggleFavorite,
  });

  @override
  MusicCardState createState() => MusicCardState();
}

class MusicCardState extends State<MusicCard> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  @override
  void didUpdateWidget(covariant MusicCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite) {
      setState(() {
        _isFavorite = widget.isFavorite;
      });
    }
  }

  Future<void> _launchSoundCloud(BuildContext context) async {
    final Uri? url = Uri.tryParse(widget.soundCloudUrl);
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid URL: ${widget.soundCloudUrl}")),
      );
      return;
    }
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Impossible to reach $url")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => _launchSoundCloud(context),
                icon: const Icon(Icons.music_note),
                label: const Text("Listen"),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                  widget.toggleFavorite(widget.gameTitle, widget.title);
                },
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavoritePage extends StatelessWidget {
  final Map<String, Set<String>> favoriteTracks;
  final Function(String, String) toggleFavorite;

  const FavoritePage({
    super.key,
    required this.favoriteTracks,
    required this.toggleFavorite,
  });

  Future<void> _launchFromFavorites(
      BuildContext context, String gameTitle, String trackTitle) async {
    String? url = await getUrlFromJson(gameTitle, trackTitle);
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible to find the URL")),
      );
      return;
    }
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Impossible to open $uri")),
      );
    }
  }

  Future<String?> getUrlFromJson(String gameTitle, String trackTitle) async {
    final jsonString = await rootBundle.loadString('assets/data.json');
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    final List<dynamic> gamesJson = jsonMap["games"];
    for (var game in gamesJson) {
      if (game["title"] == gameTitle) {
        final variants = game["variants"] as Map<String, dynamic>;
        for (var variantTracks in variants.values) {
          for (var track in variantTracks) {
            if (track["title"] == trackTitle) {
              return track["url"];
            }
          }
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: favoriteTracks.isEmpty
          ? const Center(
              child: Text("No favorite yet", style: TextStyle(fontSize: 18)),
            )
          : ListView(
              padding: const EdgeInsets.all(10),
              children: favoriteTracks.entries.map((entry) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ExpansionTile(
                    title: Text(
                      entry.key,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    children: entry.value.map((track) {
                      return ListTile(
                        title: Text(track),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.music_note),
                              onPressed: () => _launchFromFavorites(
                                  context, entry.key, track),
                            ),
                            IconButton(
                              icon: const Icon(Icons.favorite, color: Colors.red),
                              onPressed: () => toggleFavorite(entry.key, track),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
    );
  }
}

