import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';
import '../controller/app_state.dart';

class History extends StatelessWidget {
  const History({Key? key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(
                  "History of favorite words (${appState.favoriteHistory.length} words):",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...appState.favoriteHistory.asMap().entries.map(
                  (entry) {
                    int index = entry.key + 1;
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
                              backgroundColor: Colors.amber[200],
                              content: Text(
                                'its word: ${wordPair.asCamelCase}, e.g., word brightskill, show "it`s brightskill!"',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0, // Jarak dari sisi kanan layar
            child: FloatingActionButton(
              onPressed: () {
                appState.deleteAllHistory();

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text("All history deleted."),
                    ),
                  );
              },
              child: const Icon(Icons.delete),
            ),
          ),
        ],
      ),
    );
  }
}
