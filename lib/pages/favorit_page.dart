import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';
import '../controller/app_state.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kata-kata Favorit'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Anda memiliki ${appState.favorites.length} kata favorit:",
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
                                Text('Kata dihapus: ${wordPair.asCamelCase}'),
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
                              'its word: ${wordPair.asCamelCase}, e.g., word brightskill, show "it`s brightskill!"'),
                        ),
                      );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
