import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/type/Pokemon.dart';

class homePage extends StatefulWidget {
  static const String route = "/home";
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  late Future<List<Pokemon>> pokemons;
  var url = "https://pokeapi.co/api/v2/pokemon?limit=151";

  Future<List<Pokemon>> _getPokemons() async {
    final response = await http.get(Uri.parse(url));

    List<Pokemon> pokes = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map["results"];
      for (int i = 0; i < data.length; i++) {
        Pokemon poke = Pokemon(data[i]["name"], i + 1);
        print(poke.toString());
        pokes.add(poke);
      }
    } else {
      throw Exception('Ups algo salio mal');
    }
    return pokes;
  }

  @override
  void initState() {
    super.initState();
    pokemons = _getPokemons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
          title: Text("Pokédex"),
          centerTitle: true,
          backgroundColor: Colors.blue[900],
          leading: Icon(Icons.catching_pokemon),
          actions: [
            IconButton(
                onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FavPage(
                                    pokemons: fav,
                                  )))
                    },
                icon: Icon(Icons.favorite, color: Colors.white70))
          ]),
      body: FutureBuilder(
        future: pokemons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            List<Pokemon> poke = snapshot.requireData;
            return GridView.count(
              crossAxisCount: 2,
              children: _listImgs(poke),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Text("Error");
          }

          return Center(
            child: LinearProgressIndicator(),
          );
        },
      ),
    );
  }

  List<Pokemon> fav = [];
  late Pokemon info;

  List<Widget> _listImgs(List<Pokemon> data) {
    List<Widget> imgs = [];

    for (var img in data) {
      imgs.add(Card(
          color: Colors.black87,
          child: Column(
            children: [
              Expanded(
                  child: Image.network(
                img.image,
                fit: BoxFit.fill,
              )),
              Text("#${img.id}",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  IconButton(
                    onPressed: () => {
                      !fav.contains(img) ? fav.add(img) : fav.remove(img),
                      setState(() {})
                    },
                    icon: Icon(
                      !fav.contains(img)
                          ? Icons.favorite_border_outlined
                          : Icons.favorite_rounded,
                      color: Colors.red,
                    ),
                  ),
                  Text(img.getName(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  IconButton(
                    onPressed: () => {
                      setState(() {}),
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Info(pokemon: img)))
                    },
                    icon: Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                  )
                ]),
              )
            ],
          )));
    }
    return imgs;
  }

  List<Widget> getImagepoke(Pokemon data) {
    List<Widget> list = [];

    for (var sprite in data.sprites) {
      list.add(Expanded(
          child: Image.network(
        sprite,
        fit: BoxFit.fill,
      )));
    }

    return list;
  }

  List<Widget> getInfo(List<Pokemon> pokemons) {
    List<Widget> list = [];

    for (var pokemon in pokemons) {
      list.add(Expanded(child: Image.network(pokemon.image, fit: BoxFit.fill)));
      list.add(Text("#${pokemon.id} ${pokemon.getName()}",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 20)));
    }

    return list;
  }
}

class FavPage extends StatelessWidget {
  const FavPage({super.key, required this.pokemons});

  final List<Pokemon> pokemons;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Favoritos'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        leading: IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: Icon(Icons.catching_pokemon_outlined)),
      ),
      body: Column(
        children: _homePageState().getInfo(pokemons),
      ),
    );
  }
}

class Info extends StatelessWidget {
  const Info({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('¿Quien es ese pokemon?'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        leading: IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: Icon(Icons.catching_pokemon_outlined)),
      ),
      body: Column(children: [
        Text("N.°${pokemon.id}",
            style: TextStyle(color: Colors.white, fontSize: 20)),
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: Row(children: [
            Expanded(
                child: Image.network(
              pokemon.image,
              fit: BoxFit.cover,
            ))
          ]),
        ),
        Text("${pokemon.getName()}",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 20)),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(children: _homePageState().getImagepoke(pokemon)),
        )
      ]),
    );
  }
}
