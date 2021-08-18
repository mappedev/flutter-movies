import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movies/models/models.dart';
import 'package:movies/providers/movies_provider.dart';

class CastingCards extends StatelessWidget {
  final int movieId;

  const CastingCards({required this.movieId});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieId),
      builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
        if (!snapshot.hasData) {
          return _CustomizedContainer(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final castData = snapshot.data;

        if (castData == null)
          return _CustomizedContainer(
            child: Center(
              child: Text(
                'No hay actores para esta película.',
                textAlign: TextAlign.center,
              ),
            ),
          );

        return _CustomizedContainer(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: castData.length,
            itemBuilder: (_, int index) => _CastCard(
                profileImg: castData[index].fullProfileImg,
                name: castData[index].name,
            ),
          ),
        );
      },
    );
  }
}

class _CastCard extends StatelessWidget {
  final String profileImg;
  final String name;

  const _CastCard({required this.profileImg, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      width: 130.0,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/no-image.jpg'),
              image: NetworkImage(profileImg),
              width: 130.0,
              height: 190.0,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.all(2.0),
            child: Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomizedContainer extends StatelessWidget {
  final Widget child;

  const _CustomizedContainer({ required this.child });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      width: double.infinity,
      height: 250.0,
      child: child,
    );
  }
}
