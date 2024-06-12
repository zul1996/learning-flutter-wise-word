import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';
import '../controller/app_state.dart';

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
