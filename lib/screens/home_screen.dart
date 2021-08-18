import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movies/widgets/widgets.dart';

import 'package:movies/providers/movies_provider.dart';
import 'package:movies/search/movies_search_delegate.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Peliculas en cines',
          style: TextStyle(fontSize: 18.0),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => showSearch(
              context: context,
              delegate: MoviesSearchDelegate(),
            ),
            icon: Icon(Icons.search_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardSwiper(movies: moviesProvider.nowPlayingMovies),
            MovieSlider(
              movies: moviesProvider.popularMovies,
              onNextPage: moviesProvider.getPopularMovies,
            ),
          ],
        ),
      ),
    );
  }
}
