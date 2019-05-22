import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_movie_app/Movie.dart';
import 'package:http/http.dart' as http;

Future<List<Result>> getPost() async {
  final response = await http.get(
      'https://api.themoviedb.org/3/movie/top_rated?api_key=42e82cf8cc14e69e50b2f1369c96c8f4');
  print(response.body);
  if (response.statusCode == 200) {
    Movie movie = movieFromJson(response.body);
    return movie.results;
  } else {
    throw Exception('Failed to load post');
  }
}

void main() => runApp(MyApp(movie: getPost()));

class MyApp extends StatelessWidget {
  final Future<List<Result>> movie;

  MyApp({Key key, this.movie}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.red),
      home: new Scaffold(
          body: FutureBuilder<List<Result>>(
              future: movie,
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, x) {
                        return new ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SecondRoute(mov: snapshot.data[x])),
                            );
                          },
                          leading: new Hero(
                              child: GestureDetector(
                                  child: Container(
                                      width: 50.0,
                                      height: 50.0,
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                              fit: BoxFit.fill,
                                              image: new NetworkImage(
                                                  "https://image.tmdb.org/t/p/w500/" +
                                                      snapshot.data[x]
                                                          .posterPath))))),
                              tag: snapshot.data[x].title),
                          title: new Text(snapshot.data[x].title),
                        );
                      });
                else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else {
                  return CircularProgressIndicator();
                }
              })),
      //     )
    );
  }
}

class SecondRoute extends StatelessWidget {
  final Result mov;

  SecondRoute({Key key, @required this.mov}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Hero(
        tag: mov.title,
        child: GestureDetector(
          child: Column(
            children: <Widget>[
              new Container(
                width: 350.0,
                height: 350.0,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new NetworkImage(
                            "https://image.tmdb.org/t/p/w500/" +
                                mov.posterPath))),
              ),
              new Text(
                mov.title,
                style: new TextStyle(
                  fontSize: 12.0,
                  fontFamily: 'Arvo',
                  fontWeight: FontWeight.bold,
                ),
              ),
              new Text(
                mov.overview,
                style: new TextStyle(
                  fontSize: 12.0,
                  fontFamily: 'Arvo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
