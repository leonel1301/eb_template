import 'package:eb_template/models/anime_model.dart';
import 'package:eb_template/persistence/repository/anime_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  AnimeRepository animeRepository = AnimeRepository();
  List<Anime> animes = [];

  @override
  initState() {
    initialize();
    super.initState();
  }

  initialize() async {
    final favoriteAnimes = await animeRepository.getAll();
    if (mounted) {
      setState(() {
        animes = favoriteAnimes;
      });
    }
  }

  void delete(Anime anime) {
    setState(() {
      animes.remove(anime);
      animeRepository.delete(anime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your favorites'),
        actions: [
          IconButton(
            onPressed: () {
              showTotalInfoDialog(context);
            },
            icon: const Icon(Icons.info_outline),
          )
        ],
        centerTitle: true,
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: animes.isEmpty
            ? noFavorites()
            : AnimeList(
                animes: animes,
                onDelete: delete,
              ),
      ),
    );
  }
}

showTotalInfoDialog(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  int totalEpisodes = prefs.getInt('totalEpisodes') ?? 0;
  int totalMembers = prefs.getInt('totalMembers') ?? 0;

  // ignore: use_build_context_synchronously
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Datos Almacenados'),
          content: Text(
              "Total de episodios: $totalEpisodes\nTotal de miembros: $totalMembers"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            )
          ],
        );
      });
}

Widget noFavorites() {
  return const Center(
    child: Text('You have no favorites yet'),
  );
}

class AnimeList extends StatelessWidget {
  const AnimeList({super.key, required this.animes, required this.onDelete});
  final List<Anime> animes;
  final Function(Anime) onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: animes.length,
      itemBuilder: (context, index) {
        final anime = animes[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Image.network(anime.imageUrl),
            title: Text(anime.title),
            trailing: IconButton(
              onPressed: () => onDelete(anime),
              icon: const Icon(Icons.delete),
            ),
          ),
        );
      },
    );
  }
}
