import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movies/screens/screens.dart';

import 'package:movies/providers/movies_provider.dart';

void main() => runApp(AppState());
 
class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new MoviesProvider(),
          lazy: false,
        ),
      ],
      child: App(),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies',
      initialRoute: 'home',
      routes: {
        'home': (_) => HomeScreen(),
        'details': (_) => DetailsScreen(),
      },
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
        color: Colors.indigo,
      )),
    );
  }
}
