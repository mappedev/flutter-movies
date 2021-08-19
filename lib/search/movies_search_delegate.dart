import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movies/models/models.dart';
import 'package:movies/providers/movies_provider.dart';

class MoviesSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Buscar';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isNotEmpty) query = '';
        },
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      // Close es una función que me devuelve la clase al extender de SearchDelegate.
      // Con close se puede devolver un valor a donde fue llamado el search (HomeScreen)
      // Con close yo devuelvo null porque no deseo devolver nada en el momento que el usuario presione ese botón.
      onPressed: () => close(context, null),
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _EmptyContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    moviesProvider.getSuggestionsByQuery(query);

    return StreamBuilder(
      // El StreamBuilder se ejecuta cuando moviesProvider.suggestionStream emite un valor
      stream: moviesProvider.suggestionStream,
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) return _EmptyContainer();

        final moviesData = snapshot.data!;

        return ListView.builder(
          itemCount: moviesData.length,
          itemBuilder: (_, int index) => _MovieItem(movie: moviesData[index], index: index),
        );
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final int index;

  _MovieItem({required this.movie, required this.index});

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'search-${movie.title}-$index-${movie.id}';

    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          placeholder: AssetImage('assets/no-image.jpg'),
          image: NetworkImage(movie.fullPosterImg),
          width: 50.0,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      onTap: () {
        Navigator.pushNamed(context, 'details', arguments: movie);
      },
    );
  }
}

class _EmptyContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Icon(
          Icons.movie_creation_outlined,
          color: Colors.black38,
          size: 150,
        ),
      ),
    );
  }
}


