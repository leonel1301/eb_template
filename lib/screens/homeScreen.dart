import 'package:eb_template/providers/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scrollController = ScrollController();
  bool isLoading = false;
  int page = 1;
  @override
  void initState() {
    super.initState();
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    apiProvider.getCharacters(page);
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoading = true;
        });
        page++;
        await apiProvider.getCharacters(page);
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Anime App',
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: apiProvider.animeList.isNotEmpty
              ? AnimeList(
                  apiProvider: apiProvider,
                  scrollController: scrollController,
                  isLoading: isLoading,
                  page: page,
                )
              : const Center(child: CircularProgressIndicator()),
        ));
  }
}

class AnimeList extends StatelessWidget {
  const AnimeList(
      {super.key,
      required this.apiProvider,
      required this.scrollController,
      required this.isLoading,
      required this.page});
  final ApiProvider apiProvider;
  final ScrollController scrollController;
  final bool isLoading;
  final int page;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: isLoading
          ? apiProvider.animeList.length + 2
          : apiProvider.animeList.length,
      itemBuilder: (context, index) {
        if (index < apiProvider.animeList.length) {
          final anime = apiProvider.animeList[index];
          return GestureDetector(
            onTap: () {
              context.go('/description', extra: anime);
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                color: Colors.blue[100],
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Hero(
                          tag: anime.id,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              anime.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          anime.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(anime.year.toString()),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        else{
          return const Center(child: CircularProgressIndicator());
        }

      },
    );
  }
}
