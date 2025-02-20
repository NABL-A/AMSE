import 'package:flutter/material.dart';
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
      title: 'Game Soundtracks',
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
  // Favoris organisés par jeu : clé = titre du jeu, valeur = ensemble de pistes favorites
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
      const SearchPage(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoris'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Recherche'),
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

class HomePage extends StatelessWidget {
  final Function(String, String) toggleFavorite;
  final Map<String, Set<String>> favoriteTracks;

  const HomePage({
    super.key,
    required this.toggleFavorite,
    required this.favoriteTracks,
  });

  final List<Map<String, dynamic>> games = const [
    {
      "title": "The Binding of Isaac",
      "image": "assets/isaac.jpg",
    },
    {
      "title": "Super Meat Boy",
      "image": "assets/meatboy.jpg",
    },
    {
      "title": "The End is Nigh",
      "image": "assets/end_is_nigh.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jeux Vidéo")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.3,
          ),
          itemCount: games.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameDetailPage(
                      gameTitle: games[index]['title'],
                      toggleFavorite: toggleFavorite,
                      favoriteTracks: favoriteTracks,
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
                      games[index]['image'],
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      games[index]['title'],
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
    );
  }
}

class GameDetailPage extends StatelessWidget {
  final String gameTitle;
  final Function(String, String) toggleFavorite;
  final Map<String, Set<String>> favoriteTracks;

  const GameDetailPage({
    super.key,
    required this.gameTitle,
    required this.toggleFavorite,
    required this.favoriteTracks,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(gameTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bouton Musique
            ElevatedButton.icon(
              onPressed: () {
                if (gameTitle == "The Binding of Isaac") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MusicDetailPage(
                        gameTitle: gameTitle,
                        toggleFavorite: toggleFavorite,
                        favoriteTracks: favoriteTracks,
                        ostVariant: "default",
                      ),
                    ),
                  );
                } else if (gameTitle == "Super Meat Boy") {
                  // Choix entre OST 2010 et OST 2015
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Choisissez l'OST"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Text("OST 2010"),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MusicDetailPage(
                                    gameTitle: gameTitle,
                                    toggleFavorite: toggleFavorite,
                                    favoriteTracks: favoriteTracks,
                                    ostVariant: "2010",
                                  ),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            title: const Text("OST 2015"),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MusicDetailPage(
                                    gameTitle: gameTitle,
                                    toggleFavorite: toggleFavorite,
                                    favoriteTracks: favoriteTracks,
                                    ostVariant: "2015",
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Pas encore de contenu pour Musique")),
                  );
                }
              },
              icon: const Icon(Icons.music_note, size: 32),
              label: const Text("Musique", style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              ),
            ),
            const SizedBox(height: 20),
            // Bouton Artwork
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Artwork à venir")),
                );
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
  final String gameTitle;
  final String ostVariant;
  final Function(String, String) toggleFavorite;
  final Map<String, Set<String>> favoriteTracks;

  const MusicDetailPage({
    super.key,
    required this.gameTitle,
    required this.toggleFavorite,
    required this.favoriteTracks,
    required this.ostVariant,
  });

  @override
  _MusicDetailPageState createState() => _MusicDetailPageState();
}

class _MusicDetailPageState extends State<MusicDetailPage> {
  late List<String> soundCloudLinks;
  late List<String> titles;

  @override
  void initState() {
    super.initState();
    if (widget.gameTitle == "The Binding of Isaac") {
      // Liste pour Isaac (ostVariant "default")
      soundCloudLinks = [
        "https://soundcloud.com/mudeth/intro-cinematic",
        "https://soundcloud.com/mudeth/descent",
        "https://soundcloud.com/mudeth/innocence-lost",
        "https://soundcloud.com/mudeth/flashpoint-burning-basement",
        "https://soundcloud.com/mudeth/invictus-boss-fight",
        "https://soundcloud.com/mudeth/spinning-out-of-orbit",
        "https://soundcloud.com/mudeth/subterranean-homesick-malign",
        "https://soundcloud.com/mudeth/foreigner-in-zeal-flooded-caves",
        "https://soundcloud.com/mudeth/forgotten-lullaby",
        "https://soundcloud.com/mudeth/depression-shop",
        "https://soundcloud.com/mudeth/innocence-mangled",
        "https://soundcloud.com/mudeth/mithraeum-dank-depths",
        "https://soundcloud.com/mudeth/the-turn-mom-fight",
        "https://soundcloud.com/mudeth/a-baleful-circus-boss-rush",
        "https://soundcloud.com/mudeth/dystension",
        "https://soundcloud.com/mudeth/lethe-scarred-womb",
        "https://soundcloud.com/mudeth/gloria-filio",
        "https://soundcloud.com/mudeth/whitepath-angel-room",
        "https://soundcloud.com/mudeth/the-thief",
        "https://soundcloud.com/mudeth/misericorde-isaac-fight",
        "https://soundcloud.com/mudeth/ultimort",
        "https://soundcloud.com/mudeth/rapturepunk-bb-fight",
        "https://soundcloud.com/mudeth/outside-the-fold",
        "https://soundcloud.com/mudeth/esc",
        "https://soundcloud.com/mudeth/marble-forest-catacombs",
        "https://soundcloud.com/mudeth/lucidate",
        "https://soundcloud.com/mudeth/the-hammer-of-pompeii",
        "https://soundcloud.com/mudeth/blackpath-devil-room",
        "https://soundcloud.com/mudeth/shadowdance",
        "https://soundcloud.com/mudeth/spectrum-of-sin-satan-fight",
        "https://soundcloud.com/mudeth/morphine-dark-room",
        "https://soundcloud.com/mudeth/fitnah-lamb-fight",
        "https://soundcloud.com/mudeth/hallowed-ground",
        "https://soundcloud.com/mudeth/tandava",
        "https://soundcloud.com/mudeth/fault-lines",
        "https://soundcloud.com/mudeth/journey-from-a-jar-to-the-sky",
        "https://soundcloud.com/mudeth/machine-in-the-walls",
        "https://soundcloud.com/mudeth/spinning-intensifies",
        "https://soundcloud.com/mudeth/drowning",
        "https://soundcloud.com/mudeth/memento-mori",
        "https://soundcloud.com/mudeth/underscore-credits",
        "https://soundcloud.com/mudeth/an-armistice-blue-womb",
        "https://soundcloud.com/mudeth/howl-hush-fight",
        "https://soundcloud.com/mudeth/allnoise-the-void",
        "https://soundcloud.com/mudeth/terminal-lucidity-delirium",
        "https://soundcloud.com/mudeth/non-funkible-token-ultra-greed",
      ];
      titles = [
        "Track 1 - Intro Cinematic",
        "Track 2 - Descent",
        "Track 3 - Innocence Glitched",
        "Track 4 - Flashpoint",
        "Track 5 - Invictus",
        "Track 6 - Spinning Out Of Orbit ",
        "Track 7 - Subterranean Homesick Malign ",
        "Track 8 - Foreigner In Zeal",
        "Track 9 - Forgotten Lullaby ",
        "Track 10 - Depression Shop ",
        "Track 11 - Innocence Mangled ",
        "Track 12 - Mithraeum",
        "Track 13 - The Turn",
        "Track 14 - A Baleful Circus",
        "Track 15 - Dystension ",
        "Track 16 - Lethe",
        "Track 17 - Gloria Filio ",
        "Track 18 - Whitepath",
        "Track 19 - The Thief ",
        "Track 20 - Misericorde",
        "Track 21 - Ultimort ",
        "Track 22 - Rapturepunk",
        "Track 23 - Outside The Fold ",
        "Track 24 - Esc ",
        "Track 25 - Marble Forest ",
        "Track 26 - Lucidate ",
        "Track 27 - The Hammer Of Pompeii ",
        "Track 28 - Blackpath",
        "Track 29 - Shadowdance ",
        "Track 30 - Spectrum Of Sin",
        "Track 31 - Morphine Dark Room ",
        "Track 32 - Fitnah Lamb Fight ",
        "Track 33 - Hallowed Ground ",
        "Track 34 - Tandava ",
        "Track 35 - Fault Lines ",
        "Track 36 - Journey From A Jar To The Sky ",
        "Track 37 - Machine In The Walls ",
        "Track 38 - Spinning Intensifies ",
        "Track 39 - Drowning ",
        "Track 40 - Memento Mori ",
        "Track 41 - Underscore",
        "Track 42 - An Armistice",
        "Track 43 - Howl",
        "Track 44 - Allnoise",
        "Track 45 - Terminal Lucidity",
        "Track 46 - Non Funkible Token",
      ];
    } else if (widget.gameTitle == "Super Meat Boy") {
      if (widget.ostVariant == "2010") {
        soundCloudLinks = [
          "https://soundcloud.com/smb/ost2010-track1",
          "https://soundcloud.com/smb/ost2010-track2",
        ];
        titles = [
          "SMB 2010 - Track 1",
          "SMB 2010 - Track 2",
        ];
      } else if (widget.ostVariant == "2015") {
        soundCloudLinks = [
          "https://soundcloud.com/smb/ost2015-track1",
          "https://soundcloud.com/smb/ost2015-track2",
        ];
        titles = [
          "SMB 2015 - Track 1",
          "SMB 2015 - Track 2",
        ];
      } else {
        soundCloudLinks = [];
        titles = [];
      }
    } else {
      soundCloudLinks = [];
      titles = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Musiques - ${widget.gameTitle}")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.5,
          ),
          itemCount: soundCloudLinks.length,
          itemBuilder: (context, index) {
            return MusicCard(
              gameTitle: widget.gameTitle,
              title: titles[index],
              soundCloudUrl: soundCloudLinks[index],
              isFavorite: widget.favoriteTracks[widget.gameTitle]
                      ?.contains(titles[index]) ??
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
        SnackBar(content: Text("URL invalide : ${widget.soundCloudUrl}")),
      );
      return;
    }
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Impossible d’ouvrir $url")),
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
                label: const Text("Écouter"),
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

// Map pour retrouver l'URL SoundCloud pour The Binding of Isaac (exemple)
const Map<String, String> isaacTrackToUrl = {
  "Track 1 - Intro Cinematic": "https://soundcloud.com/mudeth/intro-cinematic",
  "Track 2 - Descent": "https://soundcloud.com/mudeth/descent",
  "Track 3 - Innocence Glitched":
      "https://soundcloud.com/mudeth/innocence-lost",
};

class FavoritePage extends StatelessWidget {
  final Map<String, Set<String>> favoriteTracks;
  final Function(String, String) toggleFavorite;

  const FavoritePage({
    super.key,
    required this.favoriteTracks,
    required this.toggleFavorite,
  });

  Future<void> _launchFromFavorites(
      BuildContext context, String gameTitle, String track) async {
    String? url;
    if (gameTitle == "The Binding of Isaac") {
      url = isaacTrackToUrl[track];
    }
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("URL non disponible")),
      );
      return;
    }
    final Uri? uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Impossible d’ouvrir $uri")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favoris")),
      body: favoriteTracks.isEmpty
          ? const Center(
              child:
                  Text("Aucun favori ajouté", style: TextStyle(fontSize: 18)),
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
                              icon:
                                  const Icon(Icons.favorite, color: Colors.red),
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

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Page de Recherche', style: TextStyle(fontSize: 24)),
    );
  }
}
