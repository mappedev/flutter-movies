import 'package:flutter/material.dart';
import 'package:movies/models/models.dart';

import 'package:movies/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Movie movie =
        ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(backdropImg: movie.fullBackdropImg, title: movie.title),
          SliverList(
            delegate: SliverChildListDelegate([
              _PosterAndTitle(
                heroId: movie.heroId!,
                posterImg: movie.fullPosterImg,
                title: movie.title,
                originalTitle: movie.originalTitle,
                voteAverage: movie.voteAverage.toString(),
              ),
              _Overview(text: movie.overview),
              _Overview(text: movie.overview),
              _Overview(text: movie.overview),
              CastingCards(movieId: movie.id),
            ]),
          )
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final String backdropImg;
  final String title;

  _CustomAppBar({required this.backdropImg, required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: EdgeInsets.zero,
        title: Container(
          padding: EdgeInsets.only(bottom: 16.0, left: 44.0, right: 44.0),
          alignment: Alignment.bottomCenter,
          color: Colors.black12,
          child: Text(
            title,
            style: TextStyle(fontSize: 18.0),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        background: FadeInImage(
          placeholder: AssetImage('assets/loading.gif'),
          image: NetworkImage(backdropImg),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final String heroId;
  final String posterImg;
  final String title;
  final String originalTitle;
  final String voteAverage;

  _PosterAndTitle({
    required this.heroId,
    required this.posterImg,
    required this.title,
    required this.originalTitle,
    required this.voteAverage,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 20.0),
            child: Hero(
              tag: heroId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(posterImg),
                  height: 150.0,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  originalTitle,
                  style: textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 2.0),
                      child: Icon(
                        Icons.star_outline,
                        size: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      voteAverage,
                      style: textTheme.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final String text;

  _Overview({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(text,
          textAlign: TextAlign.justify,
          style: Theme.of(context).textTheme.subtitle1,),
    );
  }
}
