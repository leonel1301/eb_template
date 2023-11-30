import 'package:eb_template/models/anime_model.dart';
import 'package:eb_template/providers/api_provider.dart';
import 'package:eb_template/screens/favoriteScreen.dart';
import 'package:eb_template/widgets/navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'screens/screens.dart';

void main() {
  runApp(const MainApp());
}

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
        path: '/',
        builder: (context, state) {
          return const AppNavigation();
        },
        routes: [
          GoRoute(
              path: 'description',
              builder: (context, state) {
                final anime = state.extra as Anime;
                return DescriptionScreen(anime: anime);
              }),
        ]),
    GoRoute(
      path: '/favorite',
      builder: (context, state) => const FavoriteScreen(),
    ),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(    
      child: ChangeNotifierProvider(
        create: (context) => ApiProvider(),
        child: MaterialApp.router(
          title: 'Anime App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
          ),
          routerConfig: router,
        ),
      ),
    );
  }
}
