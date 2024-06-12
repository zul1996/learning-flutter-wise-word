import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

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
    notifyListeners();
  }
}
