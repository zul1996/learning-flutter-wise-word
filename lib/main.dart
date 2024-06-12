// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/app_state.dart';
import 'pages/favorit_page.dart';
import 'pages/history.dart';

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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;

    switch (selectedIndex) {
      case 0:
        page = const GeneratorPage();
        break;
      case 1:
        page = const FavoritePage();
        break;
      case 2:
        page = const History();
        break;
      default:
        page = const GeneratorPage();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber, // Warna latar belakang appbar
        title: const Text(
          'MyApp',
          style: TextStyle(
            fontSize: 20, // Ukuran teks judul
            fontWeight: FontWeight.bold, // Ketebalan teks judul
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Tindakan yang akan dijalankan saat tombol pencarian ditekan
            },
            icon: const Icon(Icons.search), // Icon untuk tombol pencarian
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            Colors.amber, // Warna latar belakang bottom navigation bar
        selectedItemColor: Colors.black, // Warna teks item yang dipilih
        unselectedItemColor: Colors.grey, // Warna teks item yang tidak dipilih
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        currentIndex: selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_outlined),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            label: 'History',
          ),
        ],
      ),
      body: page,
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
          const Text(
            "My random Idea:",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.normal,
            ),
          ),
          BigCards(pair: pair),
          const SizedBox(height: 10),
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
                      backgroundColor: Colors.amber[200],
                      content: Text(
                        appState.favorites.contains(appState.current)
                            ? 'Ditambahkan ke Favorit: ${appState.current.asPascalCase}'
                            : 'Dihapus dari Favorit: ${appState.current.asPascalCase}',
                        style: TextStyle(
                          color: Colors
                              .black, // Warna teks diubah menjadi hitam untuk memberikan kontras yang lebih baik
                        ),
                      ),
                    ));
                },
                icon: Icon(icon),
                label: const Text("Favorit"),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
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

    return Card(
      color: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          pair.asLowerCase,
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 30.0,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
    );
  }
}
