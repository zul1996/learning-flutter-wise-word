import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Test Drive',
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow)),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[];
  var favoriteHistory = <WordPair>[]; // Daftar untuk menyimpan riwayat

  void generateNextWord() {
    current = WordPair.random();
    notifyListeners();
  }

  void toggleFavorit() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
      if (!favoriteHistory.contains(current)) {
        favoriteHistory.add(current); // Tambahkan ke riwayat jika belum ada
      }
    }
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }

  void deleteAllHistory() {
    favoriteHistory.clear();
    favorites.clear();
    notifyListeners();
  }

  void sendFavoriteWord() {
    print("Kata favorit terkirim: ${current.asPascalCase}");
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Words'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "You have ${appState.favorites.length} favorite words:",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...appState.favorites.asMap().entries.map(
              (entry) {
                int index = entry.key + 1;
                WordPair wordPair = entry.value;
                return ListTile(
                  title: Text('$index. ${wordPair.asCamelCase}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      appState.removeFavorite(wordPair);

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content:
                                Text('Deleted word: ${wordPair.asCamelCase}'),
                          ),
                        );
                    },
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(
                              'its: ${wordPair.asCamelCase}, e.g.,word brightskill, show "its brightskill"'),
                        ),
                      );
                  },
                );
              },
            ).toList(),
          ],
        ),
      ),
    );
  }
}

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Menghapus semua riwayat kata favorit
              appState.deleteAllHistory();

              // Menampilkan SnackBar
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text("All history deleted."),
                  ),
                );
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "History of favorite words (${appState.favoriteHistory.length} words):",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...appState.favoriteHistory.asMap().entries.map(
              (entry) {
                int index = entry.key + 1; // Menambahkan 1 untuk nomor urut
                WordPair wordPair = entry.value;
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('$index'),
                  ),
                  title: Text(wordPair.asCamelCase),
                  onTap: () {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(
                            "It's word ${wordPair.asCamelCase}",
                          ),
                        ),
                      );
                  },
                );
              },
            ).toList(),
          ],
        ),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const GeneratorPage();
      case 1:
        page = const FavoritePage();
      case 2:
        page = const History();
      default:
        page = const GeneratorPage();
    }

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        selectedIndex: selectedIndex,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.favorite),
            icon: Icon(Icons.favorite_border_outlined),
            label: 'Favorit',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.history),
            icon: Icon(Icons.work_history_outlined),
            label: 'History',
          ),
        ],
      ),
      body: Container(
        child: page,
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("My random Idea:"),
          BigCards(pair: pair),
          SizedBox(
            height: 10,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorit();

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      content: Text(appState.favorites
                              .contains(appState.current)
                          ? 'Ditambahkan ke Favorit: ${appState.current.asPascalCase}'
                          : 'Dihapus dari Favorit: ${appState.current.asPascalCase}'),
                    ));
                },
                icon: Icon(icon),
                label: Text("Favorit"),
              ),
              SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  if (appState.favorites.contains(appState.current)) {
                    appState.sendFavoriteWord();
                  }
                  appState.generateNextWord();
                },
                child: const Text("Next"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCards extends StatelessWidget {
  const BigCards({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.onPrimary, fontSize: 30.0);

    return Card(
      color: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          pair.asLowerCase,
          style: style,
        ),
      ),
    );
  }
}
