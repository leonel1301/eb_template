import 'package:dio/dio.dart';
import 'package:eb_template/models/anime_model.dart';
import 'package:flutter/material.dart';

class ApiProvider with ChangeNotifier {
  final url = 'https://api.jikan.moe/v4/top/anime';
  late final Dio dio = Dio();
  List<Anime> animeList = [];

  Future<void> getCharacters(int page) async {
    final response = await dio.get(url, queryParameters: {'page': page.toString()});
    final List<dynamic> dataList = response.data['data'];
    final List<Anime> newAnimes = dataList.map((e) => Anime.fromJson(e)).toList();
    animeList.addAll(newAnimes);
    notifyListeners();
  }
}

