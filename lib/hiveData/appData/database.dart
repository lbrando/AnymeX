import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppData extends ChangeNotifier {
  dynamic watchedAnimes;
  dynamic readMangas;
  dynamic novelList;
  bool? isGrid;
  bool? usingConsumet;

  AppData() {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      var box = await Hive.openBox('app-data');
      watchedAnimes = box.get('currently-watching', defaultValue: []);
      readMangas = box.get('currently-reading', defaultValue: []);
      isGrid = box.get('grid-context', defaultValue: false);
      usingConsumet = box.get('using-consumet', defaultValue: false);
      novelList = box.get('currently-noveling', defaultValue: []);
      notifyListeners();
    } catch (e) {
      log('Failed to load data from Hive: $e');
    }
  }

  void setWatchedAnimes(dynamic animes) {
    watchedAnimes = animes;
    var box = Hive.box('app-data');
    box.put('currently-watching', animes);
    notifyListeners();
  }

  void addWatchedAnime({
    required int animeId,
    required String animeTitle,
    required String currentEpisode,
    required String animePosterImageUrl,
  }) {
    watchedAnimes ??= [];

    final newAnime = {
      'animeId': animeId,
      'animeTitle': animeTitle,
      'currentEpisode': currentEpisode,
      'poster': animePosterImageUrl,
    };

    watchedAnimes!.removeWhere((anime) => anime['animeId'] == animeId);
    watchedAnimes!.add(newAnime);

    var box = Hive.box('app-data');
    box.put('currently-watching', watchedAnimes);
    notifyListeners();
  }

  void addReadNovels({
    required String novelId,
    required String novelTitle,
    required String chapterNumber,
    required String chapterId,
    required String novelImage,
  }) {
    novelList ??= [];

    final newNovel = {
      'novelId': novelId,
      'novelTitle': novelTitle,
      'chapterNumber': chapterNumber,
      'chapterId': chapterId,
      'novelImage': novelImage
    };

    novelList.removeWhere((novel) => novel['novelId'] == novelId);
    novelList.add(newNovel);
    novelList = novelList.reversed.toList();

    var box = Hive.box('app-data');
    box.put('currently-noveling', novelList);
    log(box.get('currently-noveling').toString());
    notifyListeners();
  }

  void setReadMangas(dynamic mangas) {
    readMangas = mangas;
    var box = Hive.box('app-data');
    box.put('currently-reading', mangas);
    notifyListeners();
  }

  void addReadManga({
    required String mangaId,
    required String mangaTitle,
    required String currentChapter,
    required String mangaPosterImage,
  }) {
    readMangas ??= [];

    final newManga = {
      'mangaId': mangaId,
      'mangaTitle': mangaTitle,
      'currentChapter': currentChapter,
      'poster': mangaPosterImage,
    };

    readMangas!.removeWhere((manga) => manga['mangaId'] == mangaId);
    readMangas!.add(newManga);

    var box = Hive.box('app-data');
    box.put('currently-reading', readMangas);
    notifyListeners();
  }

  void setIsGrid(bool isGrid) {
    this.isGrid = isGrid;
    var box = Hive.box('app-data');
    box.put('grid-context', isGrid);
    notifyListeners();
  }

  dynamic getAnimeById(String animeId) {
    return watchedAnimes?.firstWhere(
      (anime) => anime['animeId'] == animeId,
      orElse: () => {},
    );
  }

  dynamic getMangaById(String mangaId) {
    return readMangas?.firstWhere(
      (manga) => manga['mangaId'] == mangaId,
      orElse: () => {},
    );
  }

  String? getCurrentEpisodeForAnime(String animeId) {
    final anime = getAnimeById(animeId);
    return anime?['currentEpisode'] ?? '1';
  }

  String? getCurrentChapterForManga(String mangaId) {
    final manga = getMangaById(mangaId);
    return manga?['currentChapter'];
  }
}
