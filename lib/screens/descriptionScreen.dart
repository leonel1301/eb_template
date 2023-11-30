import 'package:eb_template/models/anime_model.dart';
import 'package:eb_template/persistence/repository/anime_repository.dart';
import 'package:flutter/material.dart';

class DescriptionScreen extends StatefulWidget {
  const DescriptionScreen({super.key, required this.anime});

  final Anime anime;

  @override
  State<DescriptionScreen> createState() => _DescriptionScreen();
}

class _DescriptionScreen extends State<DescriptionScreen> {
  AnimeRepository animeRepository = AnimeRepository();
  late Anime anime;

  bool isFavorite = false;

  @override
  initState() {
    anime = widget.anime;
    initialize();
    super.initState();
  }

  initialize() async {
    final exist = await animeRepository.existById(widget.anime.id);

    if (mounted) {
      setState(() {
        isFavorite = exist;
      });
    }
  }

  @override
  Widget build(BuildContext context) {  
    void handleToggleFavorite() {
      setState(() {
        isFavorite = !isFavorite;
      });
      isFavorite
          ? animeRepository.insert(anime)
          : animeRepository.delete(anime);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.anime.title),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 32),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Hero(
                  tag: widget.anime.id,
                  child: Image(image: NetworkImage(widget.anime.imageUrl))),
            ),
            SizedBox(
              child: IconButton(
                onPressed: handleToggleFavorite,
                icon: Icon(isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border_outlined),
                iconSize: 30,
                color: isFavorite ? Colors.redAccent : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget cardDataRow(String text1, String text2) {
  Color color;
  switch (text2) {
    case 'Alive':
      color = Colors.lightGreen;
      break;
    case 'Dead':
      color = Colors.redAccent;
      break;
    default:
      color = const Color(0xffeaeaea);
  }
  return Expanded(
    child: Card(
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text1),
          Text(
            text2,
            style: const TextStyle(overflow: TextOverflow.ellipsis),
          )
        ],
      ),
    ),
  );
}

Widget cardDataColumn(String text1, String text2) {
  return Expanded(
    child: Card(
      color: const Color(0xffeaeaea),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Text(text1),
          const Icon(Icons.arrow_right),
          const SizedBox(width: 8),
          Text(text2),
        ],
      ),
    ),
  );
}
