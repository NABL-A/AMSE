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
      title: 'Edmund <3',
      theme: ThemeData(fontFamily: 'Outfit'),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Outfit',
      ),
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
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorite'),
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
      appBar: AppBar(title: const Text("Edmund <3")),
      body: Padding(
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
                            children: [
                              const TextSpan(
                                text:
                                    "Edmund McMillen (né le 2 mars 1980 à Santa Cruz en Californie) est un game designer américain. ",
                              ),
                              const TextSpan(
                                text:
                                    "Créateur de Gish, Super Meat Boy et The Binding of Isaac, ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
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
                            width: 130,
                            height: 130,
                          ),
                          const SizedBox(height: 12),
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
          ],
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
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Choose the OST"),
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
                } else if (gameTitle == "The End is Nigh") {
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
            if (gameTitle == "The Binding of Isaac")
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
        "Track 6 - Spinning Out Of Orbit",
        "Track 7 - Subterranean Homesick Malign",
        "Track 8 - Foreigner In Zeal",
        "Track 9 - Forgotten Lullaby",
        "Track 10 - Depression Shop",
        "Track 11 - Innocence Mangled",
        "Track 12 - Mithraeum",
        "Track 13 - The Turn",
        "Track 14 - A Baleful Circus",
        "Track 15 - Dystension",
        "Track 16 - Lethe",
        "Track 17 - Gloria Filio",
        "Track 18 - Whitepath",
        "Track 19 - The Thief",
        "Track 20 - Misericorde",
        "Track 21 - Ultimort",
        "Track 22 - Rapturepunk",
        "Track 23 - Outside The Fold",
        "Track 24 - Esc",
        "Track 25 - Marble Forest",
        "Track 26 - Lucidate",
        "Track 27 - The Hammer Of Pompeii",
        "Track 28 - Blackpath",
        "Track 29 - Shadowdance",
        "Track 30 - Spectrum Of Sin",
        "Track 31 - Morphine Dark Room",
        "Track 32 - Fitnah Lamb Fight",
        "Track 33 - Hallowed Ground",
        "Track 34 - Tandava",
        "Track 35 - Fault Lines",
        "Track 36 - Journey From A Jar To The Sky",
        "Track 37 - Machine In The Walls",
        "Track 38 - Spinning Intensifies",
        "Track 39 - Drowning",
        "Track 40 - Memento Mori",
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
          "https://soundcloud.com/sky-5644-old/forest-funk-ch-1-light-world",
          "https://soundcloud.com/sky-5644-old/ballad-of-the-burning-squirrel",
          "https://soundcloud.com/sky-5644-old/the-battle-of-lil-slugger-ch-1",
          "https://soundcloud.com/sky-5644-old/betus-blues-ch-2-light-world",
          "https://soundcloud.com/sky-5644-old/c-h-a-d-s-broken-wind-ch-2",
          "https://soundcloud.com/sky-5644-old/c-h-a-d-s-lullaby-ch-2-boss",
          "https://soundcloud.com/sky-5644-old/can-o-salt-ch-3-light-world",
          "https://soundcloud.com/sky-5644-old/rocket-rider-ch-3-dark-world",
          "https://soundcloud.com/sky-5644-old/fast-track-to-browntown-ch-3",
          "https://soundcloud.com/sky-5644-old/12-hot-damned-ch-4-light-world",
          "https://soundcloud.com/sky-5644-old/devil-n-bass-ch-4-dark-world",
          "https://soundcloud.com/sky-5644-old/meat-golem-ch-4-boss",
          "https://soundcloud.com/sky-5644-old/it-ends-ch-5-light-world",
          "https://soundcloud.com/sky-5644-old/dr-fetus-castle-ch-5-dark",
          "https://soundcloud.com/sky-5644-old/larries-lament-ch-5-boss",
          "https://soundcloud.com/sky-5644-old/it-ends-2-end-harder-ch-6",
          "https://soundcloud.com/sky-5644-old/carmeaty-burana-ch-6-boss",
          "https://soundcloud.com/sky-5644-old/escape",
          "https://soundcloud.com/sky-5644-old/mclarty-party-people-ch-7",
          "https://soundcloud.com/sky-5644-old/forest-funk-retro-ch-1-warp",
          "https://soundcloud.com/sky-5644-old/betus-blues-retro-ch-2-warp",
          "https://soundcloud.com/sky-5644-old/can-o-salt-retro-ch-3-warp",
          "https://soundcloud.com/sky-5644-old/hot-damned-retro-ch-4-warp",
          "https://soundcloud.com/sky-5644-old/it-ends-retro-ch-5-warp-zone",
        ];
        titles = [
          "SMB 2010 - Track 1 - Forest Funk",
          "SMB 2010 - Track 2 - Ballad Of The Burning Squirrel",
          "SMB 2010 - Track 3 - The Battle Of Lil Slugger",
          "SMB 2010 - Track 4 - Betus Blues",
          "SMB 2010 - Track 5 - CHAD'S Broken Wind",
          "SMB 2010 - Track 6 - CHAD'S Lullaby",
          "SMB 2010 - Track 7 - Can O Salt",
          "SMB 2010 - Track 8 - Rocket Rider",
          "SMB 2010 - Track 9 - Fast Track To Browntown",
          "SMB 2010 - Track 10 - Hot Damned",
          "SMB 2010 - Track 11 - Devil N Bass",
          "SMB 2010 - Track 12 - Meat Golem",
          "SMB 2010 - Track 13 - It Ends",
          "SMB 2010 - Track 14 - Dr Fetus Castle",
          "SMB 2010 - Track 15 - Larries Lament",
          "SMB 2010 - Track 16 - It Ends 2 End Harder",
          "SMB 2010 - Track 17 - Carmeaty Burana",
          "SMB 2010 - Track 18 - Escape",
          "SMB 2010 - Track 19 - Mclarty Party People",
          "SMB 2010 - Track 20 - Forest Funk Retro",
          "SMB 2010 - Track 21 - Betus Blues Retro",
          "SMB 2010 - Track 22 - Can O Salt Retro",
          "SMB 2010 - Track 23 - Hot Damned Retro",
          "SMB 2010 - Track 24 - It Ends Retro",
        ];
      } else if (widget.ostVariant == "2015") {
        soundCloudLinks = [
          "https://soundcloud.com/narx221/coming-to-a-deli-near-you-ridiculon-title-screen",
          "https://soundcloud.com/narx221/gristletoe-ridiculon-forest-map",
          "https://soundcloud.com/narx221/jam-bonjovi-ridiculon-forest-light",
          "https://soundcloud.com/narx221/dark-meat-ridiculon-forest-dark",
          "https://soundcloud.com/narx221/meat-rainbow-ridiculon-forest-dark",
          "https://soundcloud.com/narx221/throw-another-banjo-on-the",
          "https://soundcloud.com/narx221/amputationoverdose-scattle-hospital-map",
          "https://soundcloud.com/narx221/bedside-manner-scattle-hospital-light",
          "https://soundcloud.com/narx221/lights-out-scattle-hospital-dark",
          "https://soundcloud.com/narx221/doctors-orders-scattle-hospital-retro",
          "https://soundcloud.com/narx221/165-scattle-hospital-boss",
          "https://soundcloud.com/narx221/the-red-sea-dry-rub-scattle-salt-factory-map",
          "https://soundcloud.com/narx221/hypertension-scattle-salt-factory-light",
          "https://soundcloud.com/narx221/the-seasoning-scattle-salt-factory-dark",
          "https://soundcloud.com/narx221/white-gold-scattle-salt-factory-retro",
          "https://soundcloud.com/narx221/dash-assault-scattle-salt-factory-boss",
          "https://soundcloud.com/narx221/highway-to-hell-ridiculon-super-meat-boy-ps4-vita-switch-soundtrack-x7bpvym0g0m",
          "https://soundcloud.com/narx221/secret-satana-ridiculon-hell-light",
          "https://soundcloud.com/narx221/hell-toupe-ridiculon-hell-dark",
          "https://soundcloud.com/narx221/mintz-meat-ridiculon-hell-retro",
          "https://soundcloud.com/narx221/fasten-your-meatbelts-ridiculon-hell-boss",
          "https://soundcloud.com/narx221/steak-thru-the-heart-ridiculon-rapture-light",
          "https://soundcloud.com/narx221/dream-meater-ridiculon-super-meat-boy-ps4-vita-switch-soundtrack-zmcm7070kcg",
          "https://soundcloud.com/narx221/meat-me-in-compton-ridiculon-rapture-retro",
          "https://soundcloud.com/narx221/meat-yer-maker-ridiculon-rapture-boss",
          "https://soundcloud.com/narx221/leather-glove-well-done-ridiculon-end-menu-light-dark",
          "https://soundcloud.com/narx221/meat-continuum-ridiculon-end-light",
          "https://soundcloud.com/narx221/ashes-to-ashes-ridiculon-end-dark",
          "https://soundcloud.com/narx221/throw-another-barbie-on-the-fire-ridiculon-end-retro",
          "https://soundcloud.com/narx221/meatal-acropolis-ridiculon-end-boss",
          "https://soundcloud.com/narx221/cotton-alley-menus-laura-shigihara",
          "https://soundcloud.com/narx221/cotton-candy-laura-shigihara-cotton-alley-light",
          "https://soundcloud.com/narx221/bandage-girl-boogie-laura-shigihara-cotton-alley-dark",
        ];
        titles = [
          "SMB 2015 - Track 1 - Coming To A Deli Near You",
          "SMB 2015 - Track 2 - Gristletoe",
          "SMB 2015 - Track 3 - Jam Bonjovi",
          "SMB 2015 - Track 4 - Dark Meat",
          "SMB 2015 - Track 5 - Meat Rainbow",
          "SMB 2015 - Track 6 - Throw Another Banjo On The Fire",
          "SMB 2015 - Track 7 - Amputation/Overdose",
          "SMB 2015 - Track 8 - Bedside Manner",
          "SMB 2015 - Track 9 - Lights Out",
          "SMB 2015 - Track 10 - Doctors Orders",
          "SMB 2015 - Track 11 - 165°",
          "SMB 2015 - Track 12 - The Red Sea Dry Rub",
          "SMB 2015 - Track 13 - Hypertension",
          "SMB 2015 - Track 14 - The Seasoning",
          "SMB 2015 - Track 15 - White Gold",
          "SMB 2015 - Track 16 - Dash Assault",
          "SMB 2015 - Track 17 - Highway To Hell",
          "SMB 2015 - Track 18 - Secret Satana",
          "SMB 2015 - Track 19 - Hell Toupe",
          "SMB 2015 - Track 20 - Mintz Meat",
          "SMB 2015 - Track 21 - Fasten Your Meatbelts",
          "SMB 2015 - Track 22 - Steak Thru The Heart",
          "SMB 2015 - Track 23 - Dream Meater",
          "SMB 2015 - Track 24 - Meat Me In Compton",
          "SMB 2015 - Track 25 - Meat Yer Maker",
          "SMB 2015 - Track 26 - Leather Glove Well Done",
          "SMB 2015 - Track 27 - Meat Continuum",
          "SMB 2015 - Track 28 - Ashes To Ashes",
          "SMB 2015 - Track 29 - Throw Another Barbie On The Fire",
          "SMB 2015 - Track 30 - Meatal Acropolis",
          "SMB 2015 - Track 31 - Cotton Alley Menus",
          "SMB 2015 - Track 32 - Cotton Candy",
          "SMB 2015 - Track 33 - Bandage Girl Boogie",
        ];
      } else {
        soundCloudLinks = [];
        titles = [];
      }
    } else if (widget.gameTitle == "The End is Nigh") {
      soundCloudLinks = [
        "https://soundcloud.com/user-944299776/the-future-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/title-screen-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/the-arid-flats-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/wall-of-sorrow-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/overflow-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/ss-exodus-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/retrograde-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/the-machine-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/the-end-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/golgotha-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/ruin-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/acceptance-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/as-above-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/the-hollows-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/mortaman-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/so-below-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/ash-climber-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/cart-menu-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/blaster-massacre-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/catastrovania-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/dead-racer-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/dig-dead-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/ghosts-n-grieving-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/fallen-fantasy-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/morbid-gear-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/mystery-castle-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/pus-man-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/river-city-rancid-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/rubble-bobble-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/scab-or-die-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/spike-tales-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/the-end-is-nigh-revisit-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/the-tower-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/tombs-torture-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/ride-of-the-valkyries-bonus-ridiculon-the-end-is-nigh",
        "https://soundcloud.com/user-944299776/the-end-is-nigh-bonus-bonus-ridiculon-the-end-is-nigh",
      ];
      titles = [
        "Track 1 - The Future",
        "Track 2 - Title Screen",
        "Track 3 - The Arid Flats",
        "Track 4 - Wall Of Sorrow",
        "Track 5 - Overflow",
        "Track 6 - Ss Exodus",
        "Track 7 - Retrograde",
        "Track 8 - The Machine",
        "Track 9 - The End",
        "Track 10 - Golgotha",
        "Track 11 - Ruin",
        "Track 12 - Acceptance",
        "Track 13 - As Above",
        "Track 14 - The Hollows",
        "Track 15 - Mortaman",
        "Track 16 - So Below",
        "Track 17 - Ash Climber",
        "Track 18 - Cart Menu",
        "Track 19 - Blaster Massacre",
        "Track 20 - Catastrovania",
        "Track 21 - Dead Racer",
        "Track 22 - Dig Dead",
        "Track 23 - Ghosts N Grieving",
        "Track 24 - Fallen Fantasy",
        "Track 25 - Morbid Gear",
        "Track 26 - Mystery Castle",
        "Track 27 - Pus Man",
        "Track 28 - River City Rancid",
        "Track 29 - Rubble Bobble",
        "Track 30 - Scab Or Die",
        "Track 31 - Spike Tales",
        "Track 32 - The End Is Nigh Revisit",
        "Track 33 - The Tower",
        "Track 34 - Tombs Torture",
        "Track 35 - Ride Of The Valkyries : Bonus",
        "Track 36 - The End Is Nigh : Bonus",
      ];
    } else {
      soundCloudLinks = [];
      titles = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Musics - ${widget.gameTitle}")),
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
      BuildContext context, String gameTitle, String track) async {
    String? url;
    if (gameTitle == "The Binding of Isaac") {
      url = isaacTrackToUrl[track];
    } else if (gameTitle == "Super Meat Boy") {
      if (track.contains("2010")) {
        url = meat2010TrackToUrl[track];
      } else if (track.contains("2015")) {
        url = meat2015TrackToUrl[track];
      }
    } else if (gameTitle == "The End is Nigh") {
      url = endTrackToUrl[track];
    }
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible to find the URL")),
      );
      return;
    }
    final Uri? uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Impossible to open $uri")),
      );
    }
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

const Map<String, String> isaacTrackToUrl = {
  "Track 1 - Intro Cinematic": "https://soundcloud.com/mudeth/intro-cinematic",
  "Track 2 - Descent": "https://soundcloud.com/mudeth/descent",
  "Track 3 - Innocence Glitched":
      "https://soundcloud.com/mudeth/innocence-lost",
  "Track 4 - Flashpoint":
      "https://soundcloud.com/mudeth/flashpoint-burning-basement",
  "Track 5 - Invictus": "https://soundcloud.com/mudeth/invictus-boss-fight",
  "Track 6 - Spinning Out Of Orbit ":
      "https://soundcloud.com/mudeth/spinning-out-of-orbit",
  "Track 7 - Subterranean Homesick Malign ":
      "https://soundcloud.com/mudeth/subterranean-homesick-malign",
  "Track 8 - Foreigner In Zeal":
      "https://soundcloud.com/mudeth/foreigner-in-zeal-flooded-caves",
  "Track 9 - Forgotten Lullaby ":
      "https://soundcloud.com/mudeth/forgotten-lullaby",
  "Track 10 - Depression Shop ":
      "https://soundcloud.com/mudeth/depression-shop",
  "Track 11 - Innocence Mangled ":
      "https://soundcloud.com/mudeth/innocence-mangled",
  "Track 12 - Mithraeum": "https://soundcloud.com/mudeth/mithraeum-dank-depths",
  "Track 13 - The Turn": "https://soundcloud.com/mudeth/the-turn-mom-fight",
  "Track 14 - A Baleful Circus":
      "https://soundcloud.com/mudeth/a-baleful-circus-boss-rush",
  "Track 15 - Dystension ": "https://soundcloud.com/mudeth/dystension",
  "Track 16 - Lethe": "https://soundcloud.com/mudeth/lethe-scarred-womb",
  "Track 17 - Gloria Filio ": "https://soundcloud.com/mudeth/gloria-filio",
  "Track 18 - Whitepath": "https://soundcloud.com/mudeth/whitepath-angel-room",
  "Track 19 - The Thief ": "https://soundcloud.com/mudeth/the-thief",
  "Track 20 - Misericorde":
      "https://soundcloud.com/mudeth/misericorde-isaac-fight",
  "Track 21 - Ultimort ": "https://soundcloud.com/mudeth/ultimort",
  "Track 22 - Rapturepunk":
      "https://soundcloud.com/mudeth/rapturepunk-bb-fight",
  "Track 23 - Outside The Fold ":
      "https://soundcloud.com/mudeth/outside-the-fold",
  "Track 24 - Esc ": "https://soundcloud.com/mudeth/esc",
  "Track 25 - Marble Forest ":
      "https://soundcloud.com/mudeth/marble-forest-catacombs",
  "Track 26 - Lucidate ": "https://soundcloud.com/mudeth/lucidate",
  "Track 27 - The Hammer Of Pompeii ":
      "https://soundcloud.com/mudeth/the-hammer-of-pompeii",
  "Track 28 - Blackpath": "https://soundcloud.com/mudeth/blackpath-devil-room",
  "Track 29 - Shadowdance ": "https://soundcloud.com/mudeth/shadowdance",
  "Track 30 - Spectrum Of Sin":
      "https://soundcloud.com/mudeth/spectrum-of-sin-satan-fight",
  "Track 31 - Morphine Dark Room ":
      "https://soundcloud.com/mudeth/morphine-dark-room",
  "Track 32 - Fitnah Lamb Fight ":
      "https://soundcloud.com/mudeth/fitnah-lamb-fight",
  "Track 33 - Hallowed Ground ":
      "https://soundcloud.com/mudeth/hallowed-ground",
  "Track 34 - Tandava ": "https://soundcloud.com/mudeth/tandava",
  "Track 35 - Fault Lines ": "https://soundcloud.com/mudeth/fault-lines",
  "Track 36 - Journey From A Jar To The Sky ":
      "https://soundcloud.com/mudeth/journey-from-a-jar-to-the-sky",
  "Track 37 - Machine In The Walls ":
      "https://soundcloud.com/mudeth/machine-in-the-walls",
  "Track 38 - Spinning Intensifies ":
      "https://soundcloud.com/mudeth/spinning-intensifies",
  "Track 39 - Drowning ": "https://soundcloud.com/mudeth/drowning",
  "Track 40 - Memento Mori ": "https://soundcloud.com/mudeth/memento-mori",
  "Track 41 - Underscore": "https://soundcloud.com/mudeth/underscore-credits",
  "Track 42 - An Armistice":
      "https://soundcloud.com/mudeth/an-armistice-blue-womb",
  "Track 43 - Howl": "https://soundcloud.com/mudeth/howl-hush-fight",
  "Track 44 - Allnoise": "https://soundcloud.com/mudeth/allnoise-the-void",
  "Track 45 - Terminal Lucidity":
      "https://soundcloud.com/mudeth/terminal-lucidity-delirium",
  "Track 46 - Non Funkible Token":
      "https://soundcloud.com/mudeth/non-funkible-token-ultra-greed",
};

const Map<String, String> meat2010TrackToUrl = {
  "SMB 2010 - Track 1 - Forest Funk Ch 1 Light World":
      "https://soundcloud.com/sky-5644-old/forest-funk-ch-1-light-world",
  "SMB 2010 - Track 2 - Ballad Of The Burning Squirrel":
      "https://soundcloud.com/sky-5644-old/ballad-of-the-burning-squirrel",
  "SMB 2010 - Track 3 - The Battle Of Lil Slugger Ch 1":
      "https://soundcloud.com/sky-5644-old/the-battle-of-lil-slugger-ch-1",
  "SMB 2010 - Track 4 - Betus Blues Ch 2 Light World":
      "https://soundcloud.com/sky-5644-old/betus-blues-ch-2-light-world",
  "SMB 2010 - Track 5 - C H A D S Broken Wind Ch 2":
      "https://soundcloud.com/sky-5644-old/c-h-a-d-s-broken-wind-ch-2",
  "SMB 2010 - Track 6 - C H A D S Lullaby Ch 2 Boss":
      "https://soundcloud.com/sky-5644-old/c-h-a-d-s-lullaby-ch-2-boss",
  "SMB 2010 - Track 7 - Can O Salt Ch 3 Light World":
      "https://soundcloud.com/sky-5644-old/can-o-salt-ch-3-light-world",
  "SMB 2010 - Track 8 - Rocket Rider Ch 3 Dark World":
      "https://soundcloud.com/sky-5644-old/rocket-rider-ch-3-dark-world",
  "SMB 2010 - Track 9 - Fast Track To Browntown Ch 3":
      "https://soundcloud.com/sky-5644-old/fast-track-to-browntown-ch-3",
  "SMB 2010 - Track 10 - 12 Hot Damned Ch 4 Light World":
      "https://soundcloud.com/sky-5644-old/12-hot-damned-ch-4-light-world",
  "SMB 2010 - Track 11 - Devil N Bass Ch 4 Dark World":
      "https://soundcloud.com/sky-5644-old/devil-n-bass-ch-4-dark-world",
  "SMB 2010 - Track 12 - Meat Golem Ch 4 Boss":
      "https://soundcloud.com/sky-5644-old/meat-golem-ch-4-boss",
  "SMB 2010 - Track 13 - It Ends Ch 5 Light World":
      "https://soundcloud.com/sky-5644-old/it-ends-ch-5-light-world",
  "SMB 2010 - Track 14 - Dr Fetus Castle Ch 5 Dark":
      "https://soundcloud.com/sky-5644-old/dr-fetus-castle-ch-5-dark",
  "SMB 2010 - Track 15 - Larries Lament Ch 5 Boss":
      "https://soundcloud.com/sky-5644-old/larries-lament-ch-5-boss",
  "SMB 2010 - Track 16 - It Ends 2 End Harder Ch 6":
      "https://soundcloud.com/sky-5644-old/it-ends-2-end-harder-ch-6",
  "SMB 2010 - Track 17 - Carmeaty Burana Ch 6 Boss":
      "https://soundcloud.com/sky-5644-old/carmeaty-burana-ch-6-boss",
  "SMB 2010 - Track 18 - Escape": "https://soundcloud.com/sky-5644-old/escape",
  "SMB 2010 - Track 19 - Mclarty Party People Ch 7":
      "https://soundcloud.com/sky-5644-old/mclarty-party-people-ch-7",
  "SMB 2010 - Track 20 - Forest Funk Retro Ch 1 Warp":
      "https://soundcloud.com/sky-5644-old/forest-funk-retro-ch-1-warp",
  "SMB 2010 - Track 21 - Betus Blues Retro Ch 2 Warp":
      "https://soundcloud.com/sky-5644-old/betus-blues-retro-ch-2-warp",
  "SMB 2010 - Track 22 - Can O Salt Retro Ch 3 Warp":
      "https://soundcloud.com/sky-5644-old/can-o-salt-retro-ch-3-warp",
  "SMB 2010 - Track 23 - Hot Damned Retro Ch 4 Warp":
      "https://soundcloud.com/sky-5644-old/hot-damned-retro-ch-4-warp",
  "SMB 2010 - Track 24 - It Ends Retro Ch 5 Warp Zone":
      "https://soundcloud.com/sky-5644-old/it-ends-retro-ch-5-warp-zone",
};

const Map<String, String> meat2015TrackToUrl = {
  "SMB 2015 - Track 1 - Coming To A Deli Near You Ridiculon Title Screen":
      "https://soundcloud.com/narx221/coming-to-a-deli-near-you-ridiculon-title-screen",
  "SMB 2015 - Track 2 - Gristletoe Ridiculon Forest Map":
      "https://soundcloud.com/narx221/gristletoe-ridiculon-forest-map",
  "SMB 2015 - Track 3 - Jam Bonjovi Ridiculon Forest Light":
      "https://soundcloud.com/narx221/jam-bonjovi-ridiculon-forest-light",
  "SMB 2015 - Track 4 - Dark Meat Ridiculon Forest Dark":
      "https://soundcloud.com/narx221/dark-meat-ridiculon-forest-dark",
  "SMB 2015 - Track 5 - Meat Rainbow Ridiculon Forest Dark":
      "https://soundcloud.com/narx221/meat-rainbow-ridiculon-forest-dark",
  "SMB 2015 - Track 6 - Throw Another Banjo On The":
      "https://soundcloud.com/narx221/throw-another-banjo-on-the",
  "SMB 2015 - Track 7 - Amputationoverdose Scattle Hospital Map":
      "https://soundcloud.com/narx221/amputationoverdose-scattle-hospital-map",
  "SMB 2015 - Track 8 - Bedside Manner Scattle Hospital Light":
      "https://soundcloud.com/narx221/bedside-manner-scattle-hospital-light",
  "SMB 2015 - Track 9 - Lights Out Scattle Hospital Dark":
      "https://soundcloud.com/narx221/lights-out-scattle-hospital-dark",
  "SMB 2015 - Track 10 - Doctors Orders Scattle Hospital Retro":
      "https://soundcloud.com/narx221/doctors-orders-scattle-hospital-retro",
  "SMB 2015 - Track 11 - 165 Scattle Hospital Boss":
      "https://soundcloud.com/narx221/165-scattle-hospital-boss",
  "SMB 2015 - Track 12 - The Red Sea Dry Rub Scattle Salt Factory Map":
      "https://soundcloud.com/narx221/the-red-sea-dry-rub-scattle-salt-factory-map",
  "SMB 2015 - Track 13 - Hypertension Scattle Salt Factory Light":
      "https://soundcloud.com/narx221/hypertension-scattle-salt-factory-light",
  "SMB 2015 - Track 14 - The Seasoning Scattle Salt Factory Dark":
      "https://soundcloud.com/narx221/the-seasoning-scattle-salt-factory-dark",
  "SMB 2015 - Track 15 - White Gold Scattle Salt Factory Retro":
      "https://soundcloud.com/narx221/white-gold-scattle-salt-factory-retro",
  "SMB 2015 - Track 16 - Dash Assault Scattle Salt Factory Boss":
      "https://soundcloud.com/narx221/dash-assault-scattle-salt-factory-boss",
  "SMB 2015 - Track 17 - Highway To Hell Ridiculon Super Meat Boy Ps4 Vita Switch Soundtrack X7bpvym0g0m":
      "https://soundcloud.com/narx221/highway-to-hell-ridiculon-super-meat-boy-ps4-vita-switch-soundtrack-x7bpvym0g0m",
  "SMB 2015 - Track 18 - Secret Satana Ridiculon Hell Light":
      "https://soundcloud.com/narx221/secret-satana-ridiculon-hell-light",
  "SMB 2015 - Track 19 - Hell Toupe Ridiculon Hell Dark":
      "https://soundcloud.com/narx221/hell-toupe-ridiculon-hell-dark",
  "SMB 2015 - Track 20 - Mintz Meat Ridiculon Hell Retro":
      "https://soundcloud.com/narx221/mintz-meat-ridiculon-hell-retro",
  "SMB 2015 - Track 21 - Fasten Your Meatbelts Ridiculon Hell Boss":
      "https://soundcloud.com/narx221/fasten-your-meatbelts-ridiculon-hell-boss",
  "SMB 2015 - Track 22 - Steak Thru The Heart Ridiculon Rapture Light":
      "https://soundcloud.com/narx221/steak-thru-the-heart-ridiculon-rapture-light",
  "SMB 2015 - Track 23 - Dream Meater Ridiculon Super Meat Boy Ps4 Vita Switch Soundtrack Zmcm7070kcg":
      "https://soundcloud.com/narx221/dream-meater-ridiculon-super-meat-boy-ps4-vita-switch-soundtrack-zmcm7070kcg",
  "SMB 2015 - Track 24 - Meat Me In Compton Ridiculon Rapture Retro":
      "https://soundcloud.com/narx221/meat-me-in-compton-ridiculon-rapture-retro",
  "SMB 2015 - Track 25 - Meat Yer Maker Ridiculon Rapture Boss":
      "https://soundcloud.com/narx221/meat-yer-maker-ridiculon-rapture-boss",
  "SMB 2015 - Track 26 - Leather Glove Well Done Ridiculon End Menu Light Dark":
      "https://soundcloud.com/narx221/leather-glove-well-done-ridiculon-end-menu-light-dark",
  "SMB 2015 - Track 27 - Meat Continuum Ridiculon End Light":
      "https://soundcloud.com/narx221/meat-continuum-ridiculon-end-light",
  "SMB 2015 - Track 28 - Ashes To Ashes Ridiculon End Dark":
      "https://soundcloud.com/narx221/ashes-to-ashes-ridiculon-end-dark",
  "SMB 2015 - Track 29 - Throw Another Barbie On The Fire Ridiculon End Retro":
      "https://soundcloud.com/narx221/throw-another-barbie-on-the-fire-ridiculon-end-retro",
  "SMB 2015 - Track 30 - Meatal Acropolis Ridiculon End Boss":
      "https://soundcloud.com/narx221/meatal-acropolis-ridiculon-end-boss",
  "SMB 2015 - Track 31 - Cotton Alley Menus Laura Shigihara":
      "https://soundcloud.com/narx221/cotton-alley-menus-laura-shigihara",
  "SMB 2015 - Track 32 - Cotton Candy Laura Shigihara Cotton Alley Light":
      "https://soundcloud.com/narx221/cotton-candy-laura-shigihara-cotton-alley-light",
  "SMB 2015 - Track 33 - Bandage Girl Boogie Laura Shigihara Cotton Alley Dark":
      "https://soundcloud.com/narx221/bandage-girl-boogie-laura-shigihara-cotton-alley-dark",
};

const Map<String, String> endTrackToUrl = {
  "Track 1 - The Future Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/the-future-ridiculon-the-end-is-nigh",
  "Track 2 - Title Screen Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/title-screen-ridiculon-the-end-is-nigh",
  "Track 3 - The Arid Flats Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/the-arid-flats-ridiculon-the-end-is-nigh",
  "Track 4 - Wall Of Sorrow Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/wall-of-sorrow-ridiculon-the-end-is-nigh",
  "Track 5 - Overflow Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/overflow-ridiculon-the-end-is-nigh",
  "Track 6 - Ss Exodus Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/ss-exodus-ridiculon-the-end-is-nigh",
  "Track 7 - Retrograde Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/retrograde-ridiculon-the-end-is-nigh",
  "Track 8 - The Machine Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/the-machine-ridiculon-the-end-is-nigh",
  "Track 9 - The End Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/the-end-ridiculon-the-end-is-nigh",
  "Track 10 - Golgotha Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/golgotha-ridiculon-the-end-is-nigh",
  "Track 11 - Ruin Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/ruin-ridiculon-the-end-is-nigh",
  "Track 12 - Acceptance Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/acceptance-ridiculon-the-end-is-nigh",
  "Track 13 - As Above Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/as-above-ridiculon-the-end-is-nigh",
  "Track 14 - The Hollows Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/the-hollows-ridiculon-the-end-is-nigh",
  "Track 15 - Mortaman Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/mortaman-ridiculon-the-end-is-nigh",
  "Track 16 - So Below Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/so-below-ridiculon-the-end-is-nigh",
  "Track 17 - Ash Climber Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/ash-climber-ridiculon-the-end-is-nigh",
  "Track 18 - Cart Menu Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/cart-menu-ridiculon-the-end-is-nigh",
  "Track 19 - Blaster Massacre Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/blaster-massacre-ridiculon-the-end-is-nigh",
  "Track 20 - Catastrovania Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/catastrovania-ridiculon-the-end-is-nigh",
  "Track 21 - Dead Racer Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/dead-racer-ridiculon-the-end-is-nigh",
  "Track 22 - Dig Dead Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/dig-dead-ridiculon-the-end-is-nigh",
  "Track 23 - Ghosts N Grieving Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/ghosts-n-grieving-ridiculon-the-end-is-nigh",
  "Track 24 - Fallen Fantasy Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/fallen-fantasy-ridiculon-the-end-is-nigh",
  "Track 25 - Morbid Gear Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/morbid-gear-ridiculon-the-end-is-nigh",
  "Track 26 - Mystery Castle Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/mystery-castle-ridiculon-the-end-is-nigh",
  "Track 27 - Pus Man Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/pus-man-ridiculon-the-end-is-nigh",
  "Track 28 - River City Rancid Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/river-city-rancid-ridiculon-the-end-is-nigh",
  "Track 29 - Rubble Bobble Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/rubble-bobble-ridiculon-the-end-is-nigh",
  "Track 30 - Scab Or Die Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/scab-or-die-ridiculon-the-end-is-nigh",
  "Track 31 - Spike Tales Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/spike-tales-ridiculon-the-end-is-nigh",
  "Track 32 - The End Is Nigh Revisit Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/the-end-is-nigh-revisit-ridiculon-the-end-is-nigh",
  "Track 33 - The Tower Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/the-tower-ridiculon-the-end-is-nigh",
  "Track 34 - Tombs Torture Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/tombs-torture-ridiculon-the-end-is-nigh",
  "Track 35 - Ride Of The Valkyries Bonus Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/ride-of-the-valkyries-bonus-ridiculon-the-end-is-nigh",
  "Track 36 - The End Is Nigh Bonus Bonus Ridiculon The End Is Nigh":
      "https://soundcloud.com/user-944299776/the-end-is-nigh-bonus-bonus-ridiculon-the-end-is-nigh",
};
