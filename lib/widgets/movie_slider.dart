import 'package:flutter/material.dart';
import 'package:movies/models/models.dart';

class MovieSlider extends StatefulWidget {
  final String title;
  final List<Movie> movies;
  final Function onNextPage;

  MovieSlider({
    required this.movies,
    required this.onNextPage,
    this.title = 'Populares',
  });

  @override
  _MovieSliderState createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final scrollController = new ScrollController();

  void getNextpage() {
    final double currentScroll = scrollController.position.pixels;
    final double maxScroll = scrollController.position.maxScrollExtent - 500;

    if (currentScroll >= maxScroll) widget.onNextPage();
  }

  @override
  void initState() {
    scrollController.addListener(getNextpage);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(getNextpage);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: _screenSize.height * 0.35,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 4.0),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (_, int index) =>
                  _MoviePoster(movie: widget.movies[index], index: index),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;
  final int index;

  _MoviePoster({required this.movie, required this.index});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    movie.heroId = 'slider-${movie.title}-$index-${movie.id}';

    return Container(
      width: 130.0,
      margin: EdgeInsets.only(top: 5.0, right: 10.0, left: 10.0),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          'details',
          arguments: movie,
        ),
        child: Column(
          children: [
            Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(movie.fullPosterImg),
                  width: 130.0,
                  height: _screenSize.height * 0.25,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 2.0, top: 2.0, left: 2.0),
              child: Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
