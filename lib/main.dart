import 'package:flutter/material.dart';

import 'features/home/presentation/pages/home_page.dart';
import 'features/now_playing/presentation/pages/now_playing_main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {'/now-playing': (context) => const NowPlayingMainPage()},
    );
  }
}
